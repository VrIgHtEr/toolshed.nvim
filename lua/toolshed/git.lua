local git = {}
local a = require 'toolshed.async'
function git.clone_async(url, opts)
    if type(url) ~= 'string' then
        error('Invalid url type. Expected string but got ' .. type(url))
    end
    if opts ~= nil then
        if type(opts) ~= 'table' then
            error('Invalid opts type. Expected table but got ' .. type(opts))
        end
        if opts.dest ~= nil and type(opts.dest) ~= 'string' then
            error('Invalid dest type. Expected string but got ' .. type(opts.dest))
        end
        if opts.progress ~= nil and type(opts.progress) ~= 'function' then
            error('Invalid progress callback type. Expected function but got ' .. type(opts.progress))
        end
    end
    return a.sync(function()
        local cmd = { 'git', 'clone' }
        local callback = nil
        if opts then
            if opts.progress then
                table.insert(cmd, '--progress')
                callback = opts.progress
            end
            if opts.recurse then
                table.insert(cmd, '--recurse-submodules')
            end
        end
        table.insert(cmd, url)
        if opts and opts.dest then
            table.insert(cmd, opts.dest)
        end
        local ret, err = a.wait(a.spawn_lines_async(cmd, nil, callback))
        if not ret then
            return nil, err
        end
        return ret
    end)
end

local function parse_git_line(line)
    local index = line:find '|'
    local ret = {}
    if index then
        ret.hash = line:sub(1, index - 1)
        ret.hash = ret.hash:sub(2, ret.hash:len())
    else
        error 'malformed git log string'
    end

    local index2 = line:find('|', index + 1)
    if index2 then
        ret.time = line:sub(index + 1, index2 - 1)
    else
        error 'malformed git log string'
    end

    ret.message = line:sub(index2 + 1)
    ret.message = ret.message:sub(1, ret.message:len() - 1)

    return ret
end

function git.update_async(path, opts)
    if type(path) ~= 'string' then
        error('Invalid path type. Expected string but got ' .. type(path))
    end
    if opts ~= nil then
        if type(opts) ~= 'table' then
            error('Invalid opts type. Expected table but got ' .. type(opts))
        end
        if opts.progress ~= nil and type(opts.progress) ~= 'function' then
            error('Invalid progress callback type. Expected function but got ' .. type(opts.progress))
        end
    end
    return a.sync(function()
        local callback = nil
        if opts then
            callback = opts.progress
        end
        local ret, err = a.wait(a.spawn_lines_async({
            'git',
            'fetch',
            '--progress',
            cwd = path,
        }, nil, callback))
        if not ret then
            return nil, err
        end
        if ret ~= 0 then
            return nil, 'failed to git fetch'
        end

        local output = {}
        ret, err = a.wait(a.spawn_lines_async({
            'git',
            'log',
            '--date=relative',
            '--pretty="%H|%ad|%s"',
            '..FETCH_HEAD',
            cwd = path,
        }, function(line)
            if line then
                table.insert(output, parse_git_line(line))
            end
        end))
        if not ret then
            return nil, err
        end
        if ret ~= 0 then
            return nil, 'Failed to check for new commits'
        end

        if #output ~= 0 then
            ret, err = a.wait(a.spawn_lines_async { 'git', 'reset', '--hard', cwd = path })
            if not ret then
                return nil, err
            end
            if ret ~= 0 then
                return nil, 'failed to git reset'
            end

            ret, err = a.wait(a.spawn_lines_async { 'git', 'merge', cwd = path })
            if not ret then
                return nil, err
            end
            if ret ~= 0 then
                return nil, 'failed to git merge'
            end
        end
        return output
    end)
end
return git
