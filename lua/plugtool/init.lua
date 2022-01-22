local M = {}
local a = require 'toolshed.async'
local plugdefs = {}
local display
local discoverqueue = require('toolshed.util.generic.queue').new()
local discovering = false
local config_filename = 'plugtool_cfg.lua'
local num_discovered
local num_added
local plugins_added
local git = require 'toolshed.git'
local startupfunc = nil

local env = require 'toolshed.env'
local pendingmarker = env.var .. '/plugtool.update.pending'

local flags = {}

local function notify(message, msgtype)
    if message == nil then
        message = ''
    else
        message = tostring(message)
    end
    if not msgtype or type(msgtype) ~= 'string' then
        msgtype = 'info'
    end
    vim.schedule(function()
        vim.notify(message, msgtype, { title = 'plugtool' })
    end)
end

local function add_plugin(plugin, front)
    if type(plugin) == 'string' then
        plugin = { plugin }
    end
    if type(plugin) == 'table' then
        local plugin_url = plugin[1]
        if type(plugin_url) ~= 'string' then
            error('plugin name should be a string, but got ' .. type(plugin_url))
        end
        local slash = plugin_url:find '/'
        if slash == nil or slash == 0 then
            error('invalid plugin url format: ' .. vim.inspect(plugin_url))
        end
        local username = plugin_url:sub(1, slash - 1):trim()
        if username == '' then
            error('invalid plugin url format: ' .. vim.inspect(plugin_url))
        end
        local reponame = plugin_url:sub(slash + 1):trim()
        slash = reponame:find '/'
        if slash then
            error('invalid plugin url format: ' .. vim.inspect(plugin_url))
        end
        plugin.username = username
        plugin.reponame = reponame
        plugin_url = plugin.username .. '/' .. plugin.reponame
        if not plugins_added[plugin_url] then
            display.displayer(plugin_url) 'Queued'
            plugins_added[plugin_url] = true
            num_added = num_added + 1
            if front then
                discoverqueue:prequeue(plugin)
            else
                discoverqueue:enqueue(plugin)
            end
        end
    else
        error('invalid plugin specification type: ' .. type(plugin))
    end
end

local function read_file(path)
    local fd = vim.loop.fs_open(path, 'r', 438)
    if not fd then
        return nil, fd
    end
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
    if not dir then
        return false
    end
    vim.loop.fs_closedir(dir)
    return true
end

local install_path = vim.fn.stdpath 'data' .. '/site/pack'

local function discover(plugin, update)
    local url = plugin.username .. '/' .. plugin.reponame
    if not plugdefs[url] then
        local updated = false
        local path = install_path .. '/' .. plugin.username .. '/opt/' .. plugin.reponame
        local ret
        num_discovered = num_discovered + 1
        local displayer = display.displayer(url)
        if not folder_exists(path) then
            displayer 'Cloning'
            a.main_loop()
            local parentPath = vim.fn.fnamemodify(path, ':p:h:h')
            ret = assert(a.wait(a.spawn_async { 'mkdir', '-p', parentPath }))
            if ret ~= 0 then
                displayer 'Failed to create directory'
                error('failed to create path: ' .. parentPath)
            end
            local plugin_url = 'https://github.com/' .. url .. '.git'
            ret = a.wait(git.clone_async(plugin_url, {
                dest = path,
                progress = function(line)
                    displayer(line)
                end,
            }))
            if ret ~= 0 then
                displayer 'Failed to clone'
                error('failed to clone git repository: ' .. plugin_url)
            end
            displayer 'Cloned successfully!'
            updated = true
        elseif update then
            displayer 'Updating'
            ret = a.wait(git.update_async(path, { progress = displayer }))
            if not ret then
                displayer 'Failed to check for updates'
                error('failed to check for updates: ' .. url)
            end
            local amt = #ret
            updated = amt > 0
            if amt > 0 then
                local str = 'Updated with ' .. amt .. ' commit'
                if amt > 1 then
                    str = str .. 's'
                end
                str = str .. '!'
                displayer(str, ret)
            else
                displayer 'Up to date!'
            end
        else
            displayer 'Discovered'
        end
        local cfgpath = path .. '/' .. config_filename
        local lines = read_file(cfgpath)
        local config = nil
        if lines then
            -- plugin specifies its own configuration
            local success
            success, config = pcall(loadstring(lines))
            if not success or type(config) ~= 'table' then
                config = nil
            end
        end
        if not config then
            -- check config repository
            local reqpath = 'plugtool.repository.' .. plugin.username:gsub('[.]', '_') .. '.' .. plugin.reponame:gsub('[.]', '_')
            package.loaded[reqpath] = nil
            local success, cfg = pcall(function()
                return require(reqpath)
            end)
            if success then
                config = cfg
            end
        end
        if not config then
            -- not in config repository, set to empty for now
            config = {}
        end
        config.username = plugin.username
        config.reponame = plugin.reponame
        plugdefs[url] = { def = config }
        if config.needs ~= nil then
            for _, x in ipairs(config.needs) do
                add_plugin(x)
            end
        end
        return updated
    else
        return false
    end
end

local plugins_loaded = false

local loader = require 'plugtool.loader'
local load_sequence = {}
local function discover_loop(callback)
    if discovering then
        return
    end
    load_sequence = {}
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
                notify 'Plugin installation complete.\nPlease restart neovim'
            else
                display.close()
                load_sequence = loader(plugdefs)
                plugins_loaded = true
                if type(callback) == 'function' then
                    callback(loader())
                end
                if startupfunc then
                    startupfunc()
                end
            end
        elseif any_updated then
            plugins_loaded = true
            notify('Updated ' .. num_updated .. ' plugins.\nPlease restart neovim')
        else
            plugins_loaded = true
            a.main_loop()
            display.close()
            notify 'All plugins up to date'
        end
        env.deleteFileOrDir(pendingmarker)
        discovering = false
    end)
end

local pluginlist = nil
function M.update(callback)
    if pluginlist == nil then
        error 'cannot update before loading'
    end
    return M.setup(pluginlist, callback)
end

local function parse_flags(tbl)
    local ret = {}
    ret = {}
    if not tbl.disable_lua_cache then
        ret.cache_plugin_name = require('plugtool.constants').cache_plugin_name
        if tbl.profile_lua_cache then
            ret.profile_lua_cache = function()
                require('impatient').enable_profile()
            end
        end
    end
    return ret
end

function M.setup(plugins, callback)
    return a.run(function()
        if discovering or plugins == nil then
            return
        end
        if type(plugins) ~= nil and type(plugins) ~= 'table' then
            error 'options must be a table'
        end

        display = require('plugtool.display').new()

        startupfunc = nil
        local config_updating = nil
        local is_first_load = not pluginlist
        local cfgpath = vim.fn.stdpath 'config'

        local pending = env.file_exists(pendingmarker)
        if pending then
            plugins_loaded = true
        end

        -- only the first time
        if not pluginlist then
            flags = parse_flags(plugins)
        end
        if folder_exists(cfgpath .. '/.git') then
            config_updating = display.displayer 'config'
            if pending then
                config_updating 'Skipped'
            else
                config_updating 'Queued'
            end
        end

        local newplugins = {}
        if flags.cache_plugin_name then
            table.insert(newplugins, flags.cache_plugin_name)
        end
        table.insert(newplugins, 'vrighter/toolshed.nvim')
        for _, x in ipairs(plugins) do
            table.insert(newplugins, x)
        end
        plugins = newplugins

        num_added = 0
        plugins_added = {}
        pluginlist = plugins

        for _, plugin in ipairs(plugins) do
            add_plugin(plugin)
        end
        if not is_first_load and config_updating then
            config_updating 'Updating'
            local configupdates, err = a.wait(git.update_async(cfgpath, { progress = config_updating }))
            if err then
                config_updating('ERROR: ' .. tostring(err))
            elseif #configupdates > 0 then
                local str = 'Updated with ' .. #configupdates .. ' commit'
                if #configupdates > 1 then
                    str = str .. 's'
                end
                str = str .. '!'
                config_updating(str, configupdates)
                for k in pairs(plugins_added) do
                    display.displayer(k) 'Deferred'
                end
                a.wait(a.spawn_async { 'touch', pendingmarker })
                return
            else
                config_updating 'Up to date!'
            end
        end
        return discover_loop(callback)
    end)
end

function M.set_startup_func(func)
    if type(func) ~= 'function' then
        error 'parameter passed to set_startup_func must be a function'
    end
    if not startupfunc then
        startupfunc = func
    else
        local oldfunc = startupfunc
        startupfunc = function()
            oldfunc()
            func()
        end
    end
end

function M.load_sequence()
    return load_sequence
end

local fun = require 'toolshed.util.fun'
function M.loaded()
    return fun.tolist(fun.map(load_sequence, function(x)
        return x.url
    end))
end

function M.find_unmanaged()
    local loaded = {}
    for _, x in ipairs(M.loaded()) do
        loaded[x] = true
    end

    local detected = require 'plugtool.detect'()
    for namespace, namespace_contents in pairs(detected) do
        local plugnameprefix = namespace .. '/'
        for _, mode_contents in pairs(namespace_contents) do
            for i = #mode_contents, 1, -1 do
                local plugname = mode_contents[i]
                local plugfullname = plugnameprefix .. plugname
                if loaded[plugfullname] then
                    table.remove(mode_contents, i)
                end
            end
        end
    end
    local namespaces_to_remove = {}
    for namespace, namespace_contents in pairs(detected) do
        local keys_to_remove = {}
        for mode, mode_contents in pairs(namespace_contents) do
            if #mode_contents == 0 then
                table.insert(keys_to_remove, mode)
            end
        end
        for _, x in ipairs(keys_to_remove) do
            namespace_contents[x] = nil
        end
        local namespace_empty = true
        if pairs(namespace_contents)(namespace_contents) then
            namespace_empty = false
        end
        if namespace_empty then
            table.insert(namespaces_to_remove, namespace)
        end
    end
    for _, x in ipairs(namespaces_to_remove) do
        detected[x] = nil
    end
    return detected
end

local function list_dirs(directory)
    local pfile = assert(io.popen(("find '%s' -mindepth 1 -maxdepth 1 -type d -printf '%%f\\0'"):format(directory), 'r'))
    local list = pfile:read '*a'
    pfile:close()
    local folders = {}
    for filename in string.gmatch(list, '[^%z]+') do
        table.insert(folders, filename)
    end
    return folders
end

function M.purge_unmanaged()
    local path = vim.fn.stdpath 'data' .. '/site/pack'
    for namespace, ns_contents in pairs(M.find_unmanaged()) do
        local nspath = path .. '/' .. namespace
        for mode, m_contents in pairs(ns_contents) do
            local modepath = nspath .. '/' .. mode
            for _, x in ipairs(m_contents) do
                vim.loop.spawn('rm', { args = { '-rf', modepath .. '/' .. x } })
            end
            local mdirs = list_dirs(modepath)
            if #mdirs == 0 then
                vim.loop.spawn('rm', { args = { '-rf', modepath } })
            end
        end
        local ndirs = list_dirs(nspath)
        if #ndirs == 0 then
            vim.loop.spawn('rm', { args = { '-rf', nspath } })
        end
    end
end

function M.state(plugin)
    local plugin_state = loader()
    if type(plugin) == 'nil' then
        return plugin_state
    elseif type(plugin) ~= 'string' then
        return nil
    end
    local ret = plugin_state[plugin]
    if not ret then
        ret = {}
        plugin_state[plugin] = ret
    end
    return ret
end

function M.flag(name)
    if flags then
        return flags[name]
    end
end
return M
