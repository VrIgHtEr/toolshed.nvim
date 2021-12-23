local git = {}
local a = require 'toolshed.async'
function git.clone_async(url, opts)
    if type(url) ~= "string" then
        error("Invalid url type. Expected string but got " .. type(url))
    end
    if opts ~= nil then
        if type(opts) ~= 'table' then
            error("Invalid opts type. Expected table but got " .. type(opts))
        end
        if opts.dest ~= nil and type(opts.dest) ~= "string" then
            error("Invalid dest type. Expected string but got " ..
                      type(opts.dest))
        end
        if opts.progress ~= nil and type(opts.progress) ~= "function" then
            error(
                "Invalid progress callback type. Expected function but got " ..
                    type(opts.progress))
        end
    end
    return a.sync(function()
        local cmd = {'git', 'clone'}
        local callback = nil
        if opts then
            if opts.progress then
                table.insert(cmd, "--progress")
                callback = opts.progress
            end
            if opts.recurse then
                table.insert(cmd, "--recurse-submodules")
            end
        end
        table.insert(cmd, url)
        if opts and opts.dest then table.insert(cmd, opts.dest) end
        local ret, err = a.spawn_lines_a(cmd, nil, callback)
        if not ret then return nil, err end
        return ret
    end)
end

function git.update_async(path, opts)
    if type(path) ~= "string" then
        error("Invalid path type. Expected string but got " .. type(path))
    end
    if opts ~= nil then
        if type(opts) ~= 'table' then
            error("Invalid opts type. Expected table but got " .. type(opts))
        end
        if opts.progress ~= nil and type(opts.progress) ~= "function" then
            error(
                "Invalid progress callback type. Expected function but got " ..
                    type(opts.progress))
        end
    end
    return a.sync(function()
        local callback = nil
        if opts then callback = opts.progress end
        local ret, err = a.spawn_lines_a({
            "git",
            "fetch",
            "--progress",
            cwd = path
        }, nil, callback)
        if not ret then return nil, err end
        if ret ~= 0 then return nil, "failed to git fetch" end

        local output = {}
        ret, err = a.spawn_lines_a({
            "git",
            "log",
            '--pretty="%h|%aN|%s"',
            "..FETCH_HEAD",
            cwd = path
        }, function(line) if line then table.insert(output, line) end end)
        if not ret then return nil, err end
        if ret ~= 0 then return nil, "Failed to check for new commits" end

        if #output ~= 0 then
            ret, err = a.spawn_lines_a {"git", "reset", "--hard", cwd = path}
            if not ret then return nil, err end
            if ret ~= 0 then return nil, "failed to git reset" end

            ret, err = a.spawn_lines_a {"git", "merge", cwd = path}
            if not ret then return nil, err end
            if ret ~= 0 then return nil, "failed to git merge" end
        end
        return output
    end)
end
return a.create_await_wrappers(git)
