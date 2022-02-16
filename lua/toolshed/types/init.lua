local fnil = function() end
local types = {}
local reserved_type_names
local metamethod_names = {
    __le = { 'nil', 'function' },
    __lt = { 'nil', 'function' },
    __eq = { 'nil', 'function' },
    __band = { 'nil', 'function' },
    __bor = { 'nil', 'function' },
    __bxor = { 'nil', 'function' },
    __bnot = { 'nil', 'function' },
    __shl = { 'nil', 'function' },
    __shr = { 'nil', 'function' },
    __concat = { 'nil', 'function' },
    __pow = { 'nil', 'function' },
    __mod = { 'nil', 'function' },
    __idiv = { 'nil', 'function' },
    __div = { 'nil', 'function' },
    __mul = { 'nil', 'function' },
    __sub = { 'nil', 'function' },
    __add = { 'nil', 'function' },
    __unm = { 'nil', 'function' },
    __close = { 'nil', 'boolean' },
    __name = { 'nil', 'string' },
    __gc = { 'nil', 'function' },
    __ipairs = { 'nil', 'function' },
    __pairs = { 'nil', 'function' },
    __len = { 'nil', 'function' },
    __tostring = { 'nil', 'function' },
    __metatable = { 'table' },
    __call = { 'nil', 'function' },
    __mode = { 'nil', 'string' },
    __newindex = { 'function' },
    __index = { 'function', 'table' },
}
reserved_type_names = {
    def = function(name, proto, init)
        if type(init) ~= 'function' then
            init = nil
        end
        if type(name) == 'string' then
            if reserved_type_names[name] then
                return nil
            end
            -- if rawget(types, name) then return rawget(types, name) end
            local t = {}
            local member_vars = {}
            member_vars.__typename = name

            local MT
            MT = {
                __metatable = fnil,
                __index = member_vars,
                __newindex = function(tbl, key, val)
                    if metamethod_names[key] then
                        if MT[key] ~= nil and metamethod_names[key][1] ~= 'nil' then
                            error('Cannot overwrite metamethod: ' .. key)
                        end
                        local type_valid = false
                        for _, x in pairs(metamethod_names[key]) do
                            if type(val) == x then
                                type_valid = true
                            end
                        end
                        if not type_valid then
                            error('invalid type for metamethod: ' .. key .. ':' .. type(val))
                        end
                        if val and key == '__eq' then
                            local tmp = val
                            val = function(a, b)
                                return type(a) == 'table' and type(b) == 'table' and a.type == t and b.type == t and tmp(a, b) or rawequal(a, b)
                            end
                        end
                        rawset(MT, key, val or false)
                    else
                        rawset(tbl, key, val)
                    end
                end,
            }
            member_vars.type = setmetatable(t, MT)
            rawset(types, name, t)

            function member_vars.new(...)
                local ret = setmetatable({}, MT)
                for key, val in pairs(proto) do
                    if not metamethod_names[key] then
                        if type(val) ~= 'function' then
                            ret[key] = val
                        elseif type(val) == 'table' then
                            ret[key] = vim.deepcopy(val)
                        end
                    end
                end
                if init then
                    init(ret, ...)
                end
                return ret
            end

            for key, val in pairs(proto) do
                if type(val) == 'function' then
                    if member_vars[key] then
                        error('cannot overwrite member function: ' .. key)
                    end
                    MT.__newindex(member_vars, key, val)
                else
                    t[key] = val
                end
            end

            return t
        else
            return nil
        end
    end,
}

setmetatable(types, {
    __index = reserved_type_names,
    __metatable = fnil,
    __newindex = fnil,
})
return types
