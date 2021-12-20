local M = {}
local a = require 'toolshed.async'
local plugdefs = {}
local installqueue = require'toolshed.util.generic.queue'.new()
local installing = false
local installconfig = {}

local function install(plugin)
    local downloaded = plugdefs[plugin[1]]
    if downloaded then
        return
    else
        -- TODO validate plugin[1]
        local path = installconfig.install_path .. "/cache/" .. plugin[1]
        local ret, err = a.spawn_a {"mkdir", "-p", path}
        if not ret then
            error("failed to execute command mkdir -p " .. path .. ": " ..
                      vim.inspect(err))
        end
        if ret ~= 0 then error("failed to create path: " .. path) end
        a.main_loop()
        local parentPath = vim.fn.fnamemodify(path, ":p:h:h")
        print(parentPath)
    end
end

local function install_loop(config)
    if installing then return end
    installing = true
    installconfig = config
    a.run(function()
        while installqueue:size() > 0 do
            local plugin = installqueue:dequeue()
            install(plugin)
        end
        installing = false
    end)
end

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

function M.setup(plugins, config)
    if type(plugins) ~= nil and type(plugins) ~= "table" then
        error "options must be a table"
    end
    config = config or require 'toolshed.plugtool.config'
    if plugins == nil then return end
    for _, plugin in ipairs(plugins) do add_plugin(plugin) end
    install_loop(config)
end

return M
