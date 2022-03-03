---@class complex_t
---@field __type string
local complex_t = {}

---@class complex : complex_t
---@field real number
---@field imag number
---@field x number
---@field y number

local MT = {
    __tostring = function(tbl)
        local ret = tostring(tbl[1])
        if tbl[2] ~= 0 then
            if tbl[2] < 0 then
                ret = ret .. ' - '
                if tbl[2] ~= -1 then
                    ret = ret .. -tbl[2]
                end
            else
                ret = ret .. ' + '
                if tbl[2] ~= 1 then
                    ret = ret .. tbl[2]
                end
            end
            ret = ret .. 'i'
        end
        return ret
    end,
    __index = function(tbl, key)
        if key == 'real' or key == 'x' then
            return tbl[1]
        elseif key == 'imag' or key == 'y' then
            return tbl[2]
        end
        return complex_t[key]
    end,
    __newindex = function(tbl, key, value)
        if key == 'real' or key == 'x' then
            rawset(tbl, 1, type(value) == 'number' and value or 0)
        elseif key == 'imag' or key == 'y' then
            rawset(tbl, 2, type(value) == 'number' and value or 0)
        elseif key ~= '__type' then
            rawset(tbl, key, value)
        end
    end,
    __add = function(a, b)
        return complex_t.add(a, b)
    end,
    __sub = function(a, b)
        return complex_t.sub(a, b)
    end,
    __mul = function(a, b)
        return complex_t.mul(a, b)
    end,
    __div = function(a, b)
        return complex_t.div(a, b)
    end,
    __unm = function(a)
        return complex_t.unm(a)
    end,
    __eq = function(a, b)
        return complex_t.eq(a, b)
    end,
}

---@param a complex
---@return number
function complex_t.mag(a)
    return math.sqrt(a[1] * a[1] + a[2] * a[2])
end

---@param a complex
---@param b complex
---@return boolean
function complex_t.eq(a, b)
    return a[1] == b[1] and a[2] == b[2]
end

---@param a complex
---@return complex
function complex_t.unm(a)
    return setmetatable({ -a[1], -a[2] }, MT)
end

---@param a complex
---@return complex
function complex_t.conj(a)
    return setmetatable({ a[1], -a[2] }, MT)
end

---@param a complex|number
---@param b complex|number
---@return complex
function complex_t.mul(a, b)
    if type(a) == 'number' then
        return setmetatable({ b[1] * a, b[2] * a }, MT)
    elseif type(b) == 'number' then
        return setmetatable({ a[1] * b, a[2] * b }, MT)
    end
    return setmetatable({ a[1] * b[1] - a[2] * b[2], a[1] * b[2] + a[2] * b[1] }, MT)
end

---@param a complex|number
---@param b complex|number
---@return complex
function complex_t.div(a, b)
    if type(a) == 'number' then
        return setmetatable({ b[1] / a, b[2] / a }, MT)
    elseif type(b) == 'number' then
        return setmetatable({ a[1] / b, a[2] / b }, MT)
    end
    return complex_t.mul(a, complex_t.conj(b))
end

---@param a complex
---@param b complex
---@return complex
function complex_t.add(a, b)
    return setmetatable({ a[1] + b[1], a[2] + b[2] }, MT)
end

---@param a complex
---@param b complex
---@return complex
function complex_t.sub(a, b)
    return setmetatable({ a[1] - b[1], a[2] - b[2] }, MT)
end

---@param a complex
---@return complex
function complex_t.normalize(a)
    return a / a:mag()
end

---@param a complex|number|nil
---@param b complex|number|nil
---@return complex|nil
local function new(a, b)
    if a == nil then
        if b == nil then
            return setmetatable({ 0, 0 }, MT)
        end
    elseif type(a) == 'number' then
        if b == nil then
            return setmetatable({ a, 0 }, MT)
        elseif type(b) == 'number' then
            return setmetatable({ a, b }, MT)
        end
    elseif b == nil and type(a) == 'table' and a.__type == complex_t.__type then
        return a
    end
end

setmetatable(complex_t, {
    __index = function(_, key)
        if key == '__type' then
            return 'complex'
        end
    end,
    __newindex = function(tbl, key, value)
        if key ~= '__type' then
            rawset(tbl, key, value)
        end
    end,
})

return new
