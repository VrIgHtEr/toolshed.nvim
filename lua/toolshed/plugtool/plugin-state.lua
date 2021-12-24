local state = {}
local MT = {
    __tostring = function(x)
        return x.value.username .. '/' .. x.value.reponame
    end
}

function state.create_entry(plugins)
    local plugs = {}

    -- convert plugin definitions to entries
    for k, v in pairs(plugins) do
        local entry = {}
        local set = {}
        if v.before then
            for _, d in ipairs(v.before) do set[d] = true end
        end
        entry.before = set
        set = {}
        if v.after then for _, d in ipairs(v.after) do set[d] = true end end
        entry.after = set
        entry.value = v
        setmetatable(entry, MT)
        entry.url = tostring(entry)
        if type(v.config) == "nil" then
            entry.config = {}
        elseif type(v.config) == "function" then
            entry.config = {v.config}
        elseif type(v.config) ~= "table" then
            error("plugin configuration has an invalid type: " .. type(v.config))
        else
            local numentries = #v.config
            if numentries == 0 then
                entry.config = {}
            else
                local conf = v.config[1]
                if type(conf) == "function" then
                    entry.config = {v.config[1]}
                elseif type(conf) ~= "table" then
                    error("invalid type for plugin configuration: " ..
                              type(conf))
                else
                    if type(conf[1]) ~= "function" then
                        error "missing configuration function"
                    end
                    if conf.before then
                        if type(conf.before) ~= "string" then
                            error "invalid configuration sequencing"
                        end
                    end
                    if conf.after then
                        if type(conf.after) ~= "string" then
                            error "invalid configuration sequencing"
                        end
                    end
                    if conf.before ~= nil or conf.after ~= nil then
                        if conf.before ~= nil and conf.after ~= nil then
                            error "configuration sequencing error. before/after are mutually exclusive"
                        end
                        entry.config = {conf}
                    else
                        entry.config = {conf[1]}
                    end
                end
                for i = 2, #v.config do
                    conf = v.config[i]
                    if type(conf) ~= "table" then
                        error("invalid type for plugin configuration: " ..
                                  type(conf))
                    end
                    if type(conf[1]) ~= "function" then
                        error "missing configuration function"
                    end
                    if conf.before then
                        if type(conf.before) ~= "string" then
                            error "invalid configuration sequencing"
                        end
                    end
                    if conf.after then
                        if type(conf.after) ~= "string" then
                            error "invalid configuration sequencing"
                        end
                    end
                    if conf.before == nil and conf.after == nil then
                        error "before/after must be specified"
                    end
                    if conf.before ~= nil and conf.after ~= nil then
                        error "configuration sequencing error. before/after are mutually exclusive"
                    end
                    table.insert(entry.config, conf)
                end
            end
        end
        plugs[k] = entry
    end

    -- expand all before/after relationships and remove non-satisfied options
    for k, v in pairs(plugs) do
        local removed = {}
        for x in pairs(v.before) do
            if x == k then
                table.insert(removed, x)
            else
                local plug = plugs[x]
                if plug ~= nil then
                    plug.after[k] = true
                else
                    table.insert(removed, x)
                end
            end
        end
        for _, x in ipairs(removed) do v.before[x] = nil end

        removed = {}
        for x in pairs(v.after) do
            if x == k then
                table.insert(removed, x)
            else
                local plug = plugs[x]
                if plug ~= nil then
                    plug.before[k] = true
                else
                    table.insert(removed, x)
                end
            end
        end
        for _, x in ipairs(removed) do v.after[x] = nil end
        removed = {}
        for i, x in ipairs(v.config) do
            if type(x) == "table" then
                if x.after then
                    if not plugs[x.after] then
                        table.insert(removed, i)
                    end
                elseif x.before then
                    if not plugs[x.before] then
                        table.insert(removed, i)
                    end
                end
            end
        end
        for i = #removed, 1, -1 do table.remove(v.config, i) end
    end

    -- all entries have fully populated before/after lists
    -- and they contain only links to plugins that are in the installation list.
    -- Link entries together in before/after lists
    for _, v in pairs(plugs) do
        for k in pairs(v.before) do v.before[k] = plugs[k] end
        for k in pairs(v.after) do v.after[k] = plugs[k] end
        for _, x in ipairs(v.config) do
            if type(x) == "table" then
                if x.after then
                    x.after = plugs[x.after]
                elseif x.before then
                    x.before = plugs[x.before]
                end
            end
        end
    end
    return plugs
end

return state
