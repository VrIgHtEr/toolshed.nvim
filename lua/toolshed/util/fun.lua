local M = {}
local function iterator(table)
    local index, max = 0, #table
    return function()
        if index < max then
            index = index + 1
            return table[index]
        end
    end
end
function M.map(iter, fun)
    iter = iterator(iter)
    return function()
        local items = { iter() }
        if #items ~= 0 then
            return fun(unpack(items))
        end
    end
end
function M.where(iter, fun)
    iter = iterator(iter)
    return function()
        local items = { iter() }
        if #items == 0 then
            return
        else
            return fun(unpack(items))
        end
    end
end
function M.tolist(iter)
    local ret, x = {}, nil
    while true do
        x = { iter() }
        local count = #x
        if count == 0 then
            return ret
        elseif count == 1 then
            table.insert(ret, x[1])
        else
            table.insert(ret, x)
        end
    end
end
return M
