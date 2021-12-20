local M = {}
local a = require 'toolshed.async'
local plugdefs = {}
local installqueue = require'toolshed.util.generic.queue'.new()
local installing = false
local installconfig = {}
local config_filename = "plugtool_cfg.lua"
local config_repository = require 'toolshed.plugtool.repository'

local function add_plugin(plugin)
    if type(plugin) == 'string' then plugin = {plugin} end
    if type(plugin) == "table" then
        local plugin_url = plugin[1]
        if type(plugin_url) ~= "string" then
            error("plugin name should be a string, but got " .. type(plugin_url))
        end
        installqueue:enqueue(plugin)
    else
        error("invalid plugin specification type: " .. type(plugin))
    end
end

local function folder_exists(path) return 0 == assert(a.spawn_a {"ls", path}) end

local function discover(plugin)
    local downloaded = plugdefs[plugin[1]]
    if downloaded then
        return
    else
        print("installing plugin: " .. vim.inspect(plugin))
        -- TODO validate plugin[1]
        local path = installconfig.install_path .. "/cache/" .. plugin[1]
        a.main_loop()
        local parentPath = vim.fn.fnamemodify(path, ":p:h:h")
        local ret = assert(a.spawn_a {"mkdir", "-p", parentPath})
        if ret ~= 0 then error("failed to create path: " .. parentPath) end

        if not folder_exists(path) then
            local plugin_url = "https://github.com/" .. plugin[1] .. ".git"
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
            success, config = pcall(loadstring(table.concat(lines, "/n")))
            if not success or type(config) ~= "table" then
                config = nil
            end
        end
        if not config then
            -- check config repository
            config = config_repository[plugin[1]]
        end
        if not config then
            -- not in config repository, set to empty for now
            config = {}
        end
        config[1] = plugin[1]
        --        print(vim.inspect(config))
        plugdefs[plugin[1]] = config
        if config.needs ~= nil then
            for _, x in ipairs(config.needs) do add_plugin(x) end
        end
    end
end

local function discover_loop(config)
    if installing then return end
    installing = true
    installconfig = config
    a.run(function()
        while installqueue:size() > 0 do
            local plugin = installqueue:dequeue()
            discover(plugin)
        end
        installing = false
    end)
end

function M.setup(plugins, config)
    if type(plugins) ~= nil and type(plugins) ~= "table" then
        error "options must be a table"
    end
    config = config or require 'toolshed.plugtool.config'
    if plugins == nil then return end
    for _, plugin in ipairs(plugins) do add_plugin(plugin) end
    discover_loop(config)
end

return M
