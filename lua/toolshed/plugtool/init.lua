local M = {}
local a = require 'toolshed.async'
local plugdefs = {}
local display
local discoverqueue = require'toolshed.util.generic.queue'.new()
local discovering = false
local config_filename = "plugtool_cfg.lua"
local config_repository = require 'toolshed.plugtool.repository'
local num_discovered
local num_added
local plugins_added
local git = require 'toolshed.git'

local function add_plugin(plugin)
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
            display.displayer(plugin_url) "Queued"
            plugins_added[plugin_url] = true
            num_added = num_added + 1
            discoverqueue:enqueue(plugin)
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
        local progress = math.floor((num_discovered / num_added) * 100)
        num_discovered = num_discovered + 1
        local displayer = display.displayer(url)
        if not folder_exists(path) then
            displayer("Cloning")
            a.main_loop()
            local parentPath = vim.fn.fnamemodify(path, ":p:h:h")
            ret = assert(a.spawn_a {"mkdir", "-p", parentPath})
            if ret ~= 0 then
                displayer("Failed to create directory")
                error("failed to create path: " .. parentPath)
            end
            print(
                "[" .. progress .. "%] discovering plugin " .. num_discovered ..
                    ": " .. url)
            local plugin_url = "https://github.com/" .. url .. ".git"
            ret = git.clone_a(plugin_url, {dest = path, progress = displayer})
            if ret ~= 0 then
                displayer("Failed to clone")
                error("failed to clone git repository: " .. plugin_url)
            end
            displayer "Cloned successfully!"
            updated = true
        elseif update then
            print("[" .. progress .. "%] updating plugin " .. num_discovered ..
                      ": " .. url)
            displayer "Updating"
            ret = git.update_a(path, {progress = displayer})
            if not ret then
                displayer "Failed to check for updates"
                error("failed to check for updates: " .. url)
            end

            local amt = #ret
            if amt > 0 then
                local str = "Updated with " .. amt .. 'commit'
                if amt > 1 then str = str .. 's' end
                str = str .. '!'
                displayer(str)
            else
                displayer "Up to date!"
            end
        else
            displayer "Discovered"
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
            config = config_repository[url]
        end
        if not config then
            -- not in config repository, set to empty for now
            config = {}
        end
        if config.config == nil then
            -- try to load config function from repository
            local reqpath = 'toolshed.plugtool.repository.cfg.' ..
                                plugin.username:gsub('[.]', "_") .. '.' ..
                                plugin.reponame:gsub("[.]", "_")
            local success, func = pcall(function()
                return require(reqpath)
            end)
            if success then config.config = func end
        end
        config.username = plugin.username
        config.reponame = plugin.reponame
        plugdefs[url] = config
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
        while discoverqueue:size() > 0 do
            local updated = discover(discoverqueue:dequeue(), plugins_loaded)
            if updated then num_updated = num_updated + 1 end
            any_updated = updated or any_updated
        end
        if not plugins_loaded then
            if any_updated then
                a.main_loop()
                local success = pcall(vim.api.nvim_exec, "quitall", true)
                if not success then
                    print("Plugin installation complete. Please restart neovim")
                end
            else
                display.close()
                loader(plugdefs)
                plugins_loaded = true
                if type(callback) == "function" then
                    callback(loader())
                end
            end
        elseif any_updated then
            a.main_loop()
            local success = pcall(vim.api.nvim_exec, "quitall", true)
            if not success then
                print("Updated " .. num_updated ..
                          " plugins. Please restart neovim")
            end
        else
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
