local M = {}
local a = require 'toolshed.async'
function M.request(url)
    local command = { 'curl' }
    table.insert(command, url)
    local ret = {}
    command.stdout = function(_, data)
        if data then
            table.insert(ret, data)
        end
    end
    local code = a.wait(a.spawn_async(command))
    if code ~= 0 then
        return nil, 'RET_NONZERO:' .. code
    end
    return table.concat(ret, '')
end
return M
