local M = {}
local a = require 'toolshed.async'
local plugdefs = {}
local discoverqueue = require'toolshed.util.generic.queue'.new()
local discovering = false
local installconfig = {}
local config_filename = "plugtool_cfg.lua"
local config_repository = require 'toolshed.plugtool.repository'
local num_discovered

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
        discoverqueue:enqueue(plugin)
    else
        error("invalid plugin specification type: " .. type(plugin))
    end
end

local function folder_exists(path) return 0 == assert(a.spawn_a {"ls", path}) end

local function discover(plugin)
    local url = plugin.username .. '/' .. plugin.reponame
    if not plugdefs[url] then
        num_discovered = num_discovered + 1
        print("discovering plugin " .. num_discovered .. ": " .. url)
        local path = installconfig.install_path .. '/' .. plugin.username ..
                         '/opt/' .. plugin.reponame
        a.main_loop()
        local parentPath = vim.fn.fnamemodify(path, ":p:h:h")
        local ret = assert(a.spawn_a {"mkdir", "-p", parentPath})
        if ret ~= 0 then error("failed to create path: " .. parentPath) end

        if not folder_exists(path) then
            local plugin_url = "https://github.com/" .. url .. ".git"
            ret = assert(a.spawn_lines_a({"git", "clone", plugin_url, path},
                                         function(x) print(x) end))
            if ret ~= 0 then
                error("failed to clone git repository: " .. plugin_url)
            end
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
    end
end

local function discover_loop(config)
    if discovering then return end
    num_discovered = 0
    discovering = true
    installconfig = config
    plugdefs = {}
    a.run(function()
        while discoverqueue:size() > 0 do
            discover(discoverqueue:dequeue())
        end
        print("discovered " .. num_discovered .. ' plugins')
        local state = {}
        for _, x in ipairs(require 'toolshed.plugtool.sort'(plugdefs)) do
            print("Loading plugin: " .. x.username .. '/' .. x.reponame)
            a.main_loop()
            vim.cmd("packadd " .. x.reponame)
            if x.config then x.config(plugdefs, state) end
        end
        print("Plugins loaded!")
        discovering = false
    end)
end

function M.setup(plugins, config)
    if type(plugins) ~= nil and type(plugins) ~= "table" then
        error "options must be a table"
    end
    if discovering then error("already discovering plugins") end
    config = config or require 'toolshed.plugtool.config'
    if plugins == nil then return end
    for _, plugin in ipairs(plugins) do add_plugin(plugin) end
    discover_loop(config)
end

return M
