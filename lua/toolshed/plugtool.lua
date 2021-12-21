local M = {}
local a = require 'toolshed.async'
local plugdefs = {}
local discoverqueue = require'toolshed.util.generic.queue'.new()
local discovering = false
local installconfig = {}
local config_filename = "plugtool_cfg.lua"
local config_repository = require 'toolshed.plugtool.repository'
local num_discovered
local num_added
local plugins_added

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
            plugins_added[plugin_url] = true
            num_added = num_added + 1
            discoverqueue:enqueue(plugin)
        end
    else
        error("invalid plugin specification type: " .. type(plugin))
    end
end

local function folder_exists(path) return 0 == assert(a.spawn_a {"ls", path}) end

local function discover(plugin, update)
    local url = plugin.username .. '/' .. plugin.reponame
    if not plugdefs[url] then
        local updated = false
        local path = installconfig.install_path .. '/' .. plugin.username ..
                         '/opt/' .. plugin.reponame
        a.main_loop()
        local parentPath = vim.fn.fnamemodify(path, ":p:h:h")
        local ret = assert(a.spawn_a {"mkdir", "-p", parentPath})
        if ret ~= 0 then error("failed to create path: " .. parentPath) end

        local progress = math.floor((num_discovered / num_added) * 100)
        num_discovered = num_discovered + 1
        if not folder_exists(path) then
            print(
                "[" .. progress .. "%] discovering plugin " .. num_discovered ..
                    ": " .. url)
            local plugin_url = "https://github.com/" .. url .. ".git"
            ret = assert(a.spawn_lines_a({"git", "clone", plugin_url, path},
                                         function(x) print(x) end))
            if ret ~= 0 then
                error("failed to clone git repository: " .. plugin_url)
            end
            updated = true
        elseif update then
            print("[" .. progress .. "%] updating plugin " .. num_discovered ..
                      ": " .. url)
            local git_pull_output = {}
            ret = assert(a.spawn_lines_a({"git", "pull", cwd = path},
                                         function(x)
                table.insert(git_pull_output, x)
            end))
            if ret ~= 0 then
                error("failed to check for updates: " .. url)
            end
            git_pull_output = table.concat(git_pull_output, '\n')
            updated = git_pull_output ~= 'Already up to date.'
        end
        local cfgpath = path .. '/' .. config_filename
        local lines = {}
        ret = assert(a.spawn_lines_a({"cat", cfgpath}, function(line)
            table.insert(lines, line)
        end))
        local config = nil
        if ret == 0 then
            -- plugin specifies its own configuration
            local success
            success, config = pcall(loadstring(table.concat(lines, "\n")))
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

local function discover_loop(config, callback)
    if discovering then return end
    discovering = true
    installconfig = config
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
            local plugin_state = {}
            for _, x in ipairs(require 'toolshed.plugtool.sort'(plugdefs)) do
                a.main_loop()
                vim.cmd("packadd " .. x.reponame)
                if x.config then
                    local success = pcall(x.config, plugdefs, plugin_state)
                    if not success then
                        print(
                            "ERROR: an error occurred while configuring plugin: " ..
                                x.username .. '/' .. x.reponame)
                    end
                end
            end
            if any_updated then print("Plugin setup complete!") end
            plugins_loaded = true
            if type(callback) == "function" then
                callback(plugin_state)
            end
        elseif any_updated then
            a.main_loop()
            local success = pcall(vim.api.nvim_exec, "quitall", true)
            if not success then
                print("Updated " .. num_updated ..
                          " plugins. Please restart neovim")
            end
        else
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
    local config = require 'toolshed.plugtool.config'
    if plugins == nil then return end
    num_added = 0
    plugins_added = {}
    for _, plugin in ipairs(plugins) do add_plugin(plugin) end
    discover_loop(config, callback)
end

return M
