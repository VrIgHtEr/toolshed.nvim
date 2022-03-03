local M = {}
function M.round(x)
    if x >= 0 then
        return math.floor(x + 0.5)
    else
        return -math.floor(-x + 0.5)
    end
end

setmetatable(M, { __index = math, __metatable = function() end })
return M
