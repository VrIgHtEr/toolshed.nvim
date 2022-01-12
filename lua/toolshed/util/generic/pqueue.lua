local M = {}
local MT = {}
function MT.__index(_, k)
    return MT[k]
end

local function sink(q, index)
    local max = bit.rshift(q.size, 1)
    while index <= max do
        local child = bit.lshift(index, 1)
        if child < q.size and q[child] < q[child + 1] then
            child = child + 1
        end
        if q[index] >= q[child] then
            return
        end
        q[index], q[child] = q[child], q[index]
        index = child
    end
end

local function float(q, index)
    while index > 1 do
        local parent = bit.rshift(index, 1)
        if q[index] <= q[parent] then
            return
        end
        q[index], q[parent] = q[parent], q[index]
        index = parent
    end
end

function MT.push(q, x)
    assert(x ~= nil, 'cannot enqueue nil items')
    q.size = q.size + 1
    q[q.size] = x
    float(q, q.size)
end

function MT.pop(q)
    if q.size <= 0 then
        return
    end
    q[1], q[q.size] = q[q.size], q[1]
    local ret = q[q.size]
    table.remove(q, q.size)
    q.size = q.size - 1
    sink(q, 1)
    return ret
end

function M.new(tbl)
    local q = setmetatable({ size = 0 }, MT)
    if tbl ~= nil then
        if type(tbl) ~= 'table' then
            error 'tbl must be a table'
        end
        for i, x in ipairs(tbl) do
            q[i] = x
            q.size = q.size + 1
        end
        for i = math.floor(q.size / 2), 1, -1 do
            sink(q, i)
        end
    end
    return q
end

return M
