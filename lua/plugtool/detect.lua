local packpath = vim.fn.stdpath 'data' .. '/site/pack'

local function find_plugin_folders(directory)
    local pfile = assert(io.popen(("find '%s' -mindepth 1 -maxdepth 1 -type d -printf '%%f\\0'"):format(directory), 'r'))
    local list = pfile:read '*a'
    pfile:close()

    local folders = {}

    for filename in string.gmatch(list, '[^%z]+') do
        table.insert(folders, filename)
    end

    return folders
end

local function find_opt_and_start_folders(directory)
    local pfile = assert(io.popen(("find '%s' -mindepth 1 -maxdepth 1 -type d -printf '%%f\\0'"):format(directory), 'r'))
    local list = pfile:read '*a'
    pfile:close()

    local folders = {}

    for filename in string.gmatch(list, '[^%z]+') do
        if filename == 'opt' or filename == 'start' then
            folders[filename] = find_plugin_folders(directory .. '/' .. filename)
        end
    end

    return folders
end
local function find_pack_base_dirs(directory)
    local pfile = assert(io.popen(("find '%s' -mindepth 1 -maxdepth 1 -type d -printf '%%f\\0'"):format(directory), 'r'))
    local list = pfile:read '*a'
    pfile:close()

    local folders = {}

    for filename in string.gmatch(list, '[^%z]+') do
        folders[filename] = find_opt_and_start_folders(packpath .. '/' .. filename)
    end

    return folders
end

return function()
    return find_pack_base_dirs(packpath)
end
