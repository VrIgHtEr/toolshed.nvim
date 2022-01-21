local M = {}
local a = require 'toolshed.async'
M.root = vim.fn.stdpath 'data' .. '/env'
M.var = M.root .. '/var'
M.opt = M.root .. '/opt'
M.bin = M.root .. '/bin'
M.meta = M.var .. '/srcpkg'

function M.get_dependency_path(dirname)
    return M.opt .. '/' .. dirname
end

function M.get_dependency_meta_path(dirname)
    return M.meta .. '/' .. dirname
end

function M.file_exists(path)
    local handle = io.open(path, 'r')
    if handle == nil then
        return false
    end
    handle:close()
    return true
end

function M.path_env_add(target)
    local path = M.getPath()
    if path ~= nil then
        local exists = false
        for _, x in ipairs(path) do
            if x == target then
                exists = true
                break
            end
        end
        if not exists then
            table.insert(path, 1, target)
            vim.fn.setenv('PATH', table.concat(path, ':'))
        end
    end
end

function M.bashescape(str)
    local ret = {}
    local open = false
    for i = 1, str:len() do
        local ch = str:sub(i, i)
        if ch == "'" then
            if open then
                open = false
                table.insert(ret, "'")
            end
            table.insert(ret, '\\')
        else
            if not open then
                open = true
                table.insert(ret, "'")
            end
        end
        table.insert(ret, ch)
    end
    if open then
        table.insert(ret, "'")
    end
    ret = table.concat(ret, '')
    return ret
end

function M.bashexec(cmd)
    local exec = 'bash -c ' .. M.bashescape(cmd) .. ' 2>/dev/null'
    return os.execute(exec)
end

function M.clone_repo(repo, target, recurse)
    print('cloning repository ' .. repo .. ' to ' .. target)
    local clonecmd = 'git clone '
    if recurse then
        clonecmd = clonecmd .. '--recurse-submodules '
    end
    clonecmd = clonecmd .. M.bashescape(repo) .. ' '
    clonecmd = clonecmd .. M.bashescape(target)
    return M.bashexec(clonecmd)
end

function M.clone_repo_a(repo, target, recurse)
    print('cloning repository ' .. repo .. ' to ' .. target)
    local clonecmd = { 'git', 'clone' }
    if recurse then
        table.insert(clonecmd, '--recurse-submodules')
    end
    table.insert(clonecmd, repo)
    table.insert(clonecmd, target)
    return a.spawn_lines_a(clonecmd, print)
end

function M.deleteFileOrDir(path)
    return M.bashexec('rm -rf ' .. M.bashescape(path))
end

function M.getPath()
    local delimiter = ':'
    local env = vim.fn.getenv 'PATH' .. delimiter
    if env == nil then
        return nil
    end
    local ret = {}
    for path in env:gmatch('([^' .. delimiter .. ']*)' .. delimiter) do
        table.insert(ret, path)
    end
    return ret
end

local installing = false
local installqueue = require('toolshed.util.generic.queue').new()
installqueue:enqueue(a.spawn_async { 'mkdir', '-p', M.root })
installqueue:enqueue(a.spawn_async { 'mkdir', '-p', M.var })
installqueue:enqueue(a.spawn_async { 'mkdir', '-p', M.opt })
installqueue:enqueue(a.spawn_async { 'mkdir', '-p', M.meta })
installqueue:enqueue(a.spawn_async { 'mkdir', '-p', M.bin })

local function check_dependencies(deps)
    if not deps then
        return
    end
    if type(deps) == 'function' then
        return a.wait(a.syncwrap(deps)())
    elseif type(deps) == 'table' then
        for _, x in ipairs(deps) do
            if type(x) ~= 'function' then
                error 'invalid entry in builddeps'
            end
            local ret = a.wait(a.syncwrap(x)())
            if ret then
                return ret
            end
        end
    else
        error 'invalid entry in builddeps'
    end
end

local install_dependency_async = a.syncwrap(function(v)
    local success = false
    local target = M.get_dependency_path(v.dirname)
    local metafilepath = M.get_dependency_meta_path(v.dirname)
    local function alert(msg, err)
        local t
        if err then
            t = 'error'
        else
            t = 'info'
        end
        vim.schedule(function()
            vim.notify(msg, t, { title = v.dirname })
        end)
    end
    if not M.file_exists(metafilepath) then
        local dependency_check = check_dependencies(v.builddeps)
        if not dependency_check then
            M.deleteFileOrDir(target)
            local recurse = false
            if v.recurse_submodules then
                recurse = true
            end
            alert 'Cloning git repository'
            local ret = assert(M.clone_repo_a(v.repo, target, recurse))
            if ret == 0 then
                if type(v.buildcmd) == 'string' then
                    print('executing ' .. v.buildcmd)
                    alert('Running: ' .. v.buildcmd)
                    ret = assert(a.spawn_lines_a({ v.buildcmd, cwd = target }, print))
                    if ret == 0 then
                        success = true
                    end
                elseif type(v.buildcmd) == 'table' then
                    local failed = false
                    for _, x in ipairs(v.buildcmd) do
                        local cmd
                        if type(x) == 'string' then
                            print('executing ' .. x)
                            alert('Running: ' .. x)
                            cmd = { x }
                        elseif type(x) == 'table' then
                            cmd = x
                            alert('Running: ' .. table.concat(x, ' '))
                            print('executing ' .. table.concat(x, ' '))
                        else
                            error 'invalid cmd'
                        end
                        if not cmd.cwd then
                            cmd.cwd = target
                        end
                        ret = assert(a.spawn_lines_a(cmd, print))
                        if ret ~= 0 then
                            failed = true
                            break
                        end
                    end
                    success = not failed
                end
            end
            if success and v.launchscript ~= nil then
                local scriptname = v.launchscript.name
                if scriptname == nil then
                    scriptname = v.dirname
                end
                if type(scriptname) ~= 'string' then
                    success = false
                    print 'supplied launch script name is not a string'
                else
                    local script = v.launchscript.script
                    if script == nil then
                        success = false
                        print 'supplied launch script was nil'
                    elseif type(script) ~= 'string' then
                        success = false
                        print 'supplied launch script is not a string'
                    else
                        local scriptpath = M.bin .. '/' .. scriptname
                        M.bashexec('echo ' .. M.bashescape(script) .. ' > ' .. M.bashescape(scriptpath))
                        assert(a.spawn_a { 'chmod', '+x', scriptpath })
                    end
                end
            end
            if success then
                assert(a.spawn_a { 'touch', metafilepath })
                print(v.dirname .. ' successfully installed')
                alert 'Installation successful'
            else
                assert(a.spawn_a { 'rm', '-rf', target })
                print('installation of ' .. v.dirname .. ' unsuccessful')
                alert('Installation failed', true)
            end
            return success
        else
            alert('Build dependency not met: ' .. dependency_check, true)
            return false
        end
    else
        return true
    end
end)

local install = function()
    if not installing then
        installing = true
        return vim.schedule(a.sync(function()
            while true do
                local nextinstaller = installqueue:dequeue()
                if not nextinstaller then
                    installing = false
                    break
                end
                a.wait(nextinstaller)
            end
            installing = false
        end))
    end
end

function M.install_dependencies(deps)
    for _, dep in ipairs(deps) do
        installqueue:enqueue(install_dependency_async(dep))
    end
    if not installing then
        install()
    end
end

if not require('toolshed.util.sys.os-detect').is_linux then
    print 'only linux is supported'
    return nil
end

function M.exec_checker(tool)
    return function()
        if a.spawn_a { tool, '--version' } == nil then
            return tool
        end
    end
end

function M.nproc_async()
    return function(step)
        return a.run(function()
            local proc = nil
            local ret, err = a.spawn_lines_a({ 'nproc' }, function(line)
                if line then
                    proc = tonumber(line)
                end
            end)
            if ret == 0 then
                if proc then
                    return step(proc)
                else
                    return step(nil, 'did not get num cpus')
                end
            elseif ret == nil then
                return step(nil, err)
            else
                return step(nil, 'nonzero return code: ' .. tostring(ret))
            end
        end)
    end
end

M.path_env_add(M.bin)
return M
