local M = {}
local a = require 'toolshed.async'
local plugdefs = {}
local display
local discoverqueue = require'toolshed.util.generic.queue'.new()
local discovering = false
local config_filename = "plugtool_cfg.lua"
local num_discovered
local num_added
local plugins_added
local git = require 'toolshed.git'

local function add_plugin(plugin, front)
    if type(plugin) == 'string' then plugin = {plugin} end
    if type(plugin) == "table" then
        local plugin_url = plugin[1]
        if type(plugin_url) ~= "string" then
            error("plugin name should be a string, but got " .. type(plugin_url))
        end
        local slash = plugin_url:find '/'
        if slash == nil or slash == 0 then
            error("invalid plugin url format: " .. vim.inspect(plugin_url))
        end
        local username = plugin_url:sub(1, slash - 1):trim()
        if username == "" then
            error("invalid plugin url format: " .. vim.inspect(plugin_url))
        end
        local reponame = plugin_url:sub(slash + 1):trim()
        slash = reponame:find '/'
        if slash then
            error("invalid plugin url format: " .. vim.inspect(plugin_url))
        end
        plugin.username = username
        plugin.reponame = reponame
        plugin_url = plugin.username .. '/' .. plugin.reponame
        if not plugins_added[plugin_url] then
            display.displayer(plugin_url)(plugin_url .. ": Queued")
            plugins_added[plugin_url] = true
            num_added = num_added + 1
            if front then
                discoverqueue:prequeue(plugin)
            else
                discoverqueue:enqueue(plugin)
            end
        end
    else
        error("invalid plugin specification type: " .. type(plugin))
    end
end

local function read_file(path)
    local fd = vim.loop.fs_open(path, "r", 438)
    if not fd then return nil, fd end
    local stat = vim.loop.fs_fstat(fd)
    if not stat then
        vim.loop.fs_close(fd)
        return nil, stat
    end
    local data = vim.loop.fs_read(fd, stat.size, 0)
    if not data then
        vim.loop.fs_close(fd)
        return nil, data
    end
    vim.loop.fs_close(fd)
    return data
end

local function folder_exists(path)
    local dir = vim.loop.fs_opendir(path, nil, 1)
    if not dir then return false end
    vim.loop.fs_closedir(dir)
    return true
end

local install_path = vim.fn.stdpath("data") .. "/site/pack"

local function discover(plugin, update)
    local url = plugin.username .. '/' .. plugin.reponame
    if not plugdefs[url] then
        local updated = false
        local path = install_path .. '/' .. plugin.username .. '/opt/' ..
                         plugin.reponame
        local ret
        num_discovered = num_discovered + 1
        local displayer = display.displayer(url)
        if not folder_exists(path) then
            displayer(url .. ": Cloning")
            a.main_loop()
            local parentPath = vim.fn.fnamemodify(path, ":p:h:h")
            ret = assert(a.spawn_a {"mkdir", "-p", parentPath})
            if ret ~= 0 then
                displayer(url .. ": Failed to create directory")
                error("failed to create path: " .. parentPath)
            end
            local plugin_url = "https://github.com/" .. url .. ".git"
            ret = git.clone_a(plugin_url,
                              {
                dest = path,
                progress = function(line)
                    displayer(url .. ': ' .. line)
                end
            })
            if ret ~= 0 then
                displayer(url .. ": Failed to clone")
                error("failed to clone git repository: " .. plugin_url)
            end
            displayer(url .. ": Cloned successfully!")
            updated = true
        elseif update then
            displayer(url .. ": Updating")
            ret = git.update_a(path, {
                progress = function(line)
                    displayer(url .. ': ' .. line)
                end
            })
            if not ret then
                displayer(url .. ": Failed to check for updates")
                error("failed to check for updates: " .. url)
            end

            local amt = #ret
            updated = amt > 0
            if amt > 0 then
                local str = url .. ": Updated with " .. amt .. ' commit'
                if amt > 1 then str = str .. 's' end
                str = str .. '!'
                str = {str}
                for _, x in ipairs(ret) do
                    table.insert(str, "        " .. x.hash:sub(1, 8) .. " - " ..
                                     x.time .. " - " .. x.message)
                end
                table.insert(str, "")
                table.insert(str, "")
                displayer(table.concat(str, '\n'), ret)
            else
                displayer(url .. ": Up to date!")
            end
        else
            displayer(url .. ": Discovered")
        end
        local cfgpath = path .. '/' .. config_filename
        local lines = read_file(cfgpath)
        local config = nil
        if lines then
            -- plugin specifies its own configuration
            local success
            success, config = pcall(loadstring(lines))
            if not success or type(config) ~= "table" then
                config = nil
            end
        end
        if not config then
            -- check config repository
            local reqpath = 'toolshed.plugtool.repository.' ..
                                plugin.username:gsub('[.]', "_") .. '.' ..
                                plugin.reponame:gsub("[.]", "_")
            package.loaded[reqpath] = nil
            local success, cfg = pcall(function()
                return require(reqpath)
            end)
            if success then config = cfg end
        end
        if not config then
            -- not in config repository, set to empty for now
            config = {}
        end
        config.username = plugin.username
        config.reponame = plugin.reponame
        plugdefs[url] = {def = config}
        if config.needs ~= nil then
            for _, x in ipairs(config.needs) do add_plugin(x) end
        end
        return updated
    else
        return false
    end
end

local plugins_loaded = false

local loader = require 'toolshed.plugtool.loader'

local function discover_loop(callback)
    if discovering then return end
    discovering = true
    a.run(function()
        local any_updated = false
        local num_updated = 0
        num_discovered = 0
        plugdefs = {}

        local firstupdated = false
        local found = {}

        while discoverqueue:size() > 0 do
            local plug = discoverqueue:dequeue()
            local updated = discover(plug, plugins_loaded)
            if updated then
                num_updated = num_updated + 1
                if not firstupdated then
                    firstupdated = true
                    if not plugins_loaded then
                        plugins_loaded = true
                        local plugname = plug.username .. '/' .. plug.reponame
                        plugdefs[plugname] = nil
                        plugins_added[plugname] = nil
                        add_plugin(plug, true)
                        for i = #found, 1, -1 do
                            local v = found[i]
                            plugname = v.username .. '/' .. v.reponame
                            plugdefs[plugname] = nil
                            plugins_added[plugname] = nil
                            add_plugin(v, true)
                        end
                        found = {}
                    end
                end
            elseif not firstupdated then
                table.insert(found, plug)
            end
            any_updated = updated or any_updated
        end
        if not plugins_loaded then
            if any_updated then
                plugins_loaded = true
                print("Plugin installation complete. Please restart neovim")
            else
                display.close()
                loader(plugdefs)
                plugins_loaded = true
                if type(callback) == "function" then
                    callback(loader())
                end
            end
        elseif any_updated then
            plugins_loaded = true
            print("Updated " .. num_updated .. " plugins. Please restart neovim")
        else
            plugins_loaded = true
            a.main_loop()
            display.close()
            print("All plugins up to date")
        end
        discovering = false
    end)
end

function M.setup(plugins, callback)
    if discovering then return end
    if type(plugins) ~= nil and type(plugins) ~= "table" then
        error "options must be a table"
    end
    if plugins == nil then return end
    num_added = 0
    plugins_added = {}
    display = require'toolshed.plugtool.display'.new()
    add_plugin("vrighter/toolshed.nvim")
    for _, plugin in ipairs(plugins) do add_plugin(plugin) end
    discover_loop(callback)
end

function M.state(plugin)
    local plugin_state = loader()
    if type(plugin) == "nil" then
        return plugin_state
    elseif type(plugin) ~= "string" then
        return nil
    end
    local ret = plugin_state[plugin]
    if not ret then
        ret = {}
        plugin_state[plugin] = ret
    end
    return ret
end

function M.DEBUG_RESET() plugins_loaded = false end
return M
