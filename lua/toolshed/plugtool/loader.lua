local MT = {
    __tostring = function(x)
        return x.value.username .. '/' .. x.value.reponame
    end
}

local function create_entries(plugins)
    local plugs = {}

    -- convert plugin definitions to entries
    for k, v in pairs(plugins) do
        local entry = {}
        entry.def = v.def
        local set = {}
        if v.def.before then
            for _, d in ipairs(v.def.before) do set[d] = true end
        end
        entry.before = set
        set = {}
        if v.def.after then
            for _, d in ipairs(v.def.after) do set[d] = true end
        end
        entry.after = set
        entry.value = v.def
        setmetatable(entry, MT)
        entry.url = tostring(entry)
        if type(v.def.config) == "nil" then
            entry.config = {}
        elseif type(v.def.config) == "function" then
            entry.config = {v.def.config}
        elseif type(v.def.config) ~= "table" then
            error("plugin configuration has an invalid type: " ..
                      type(v.def.config))
        else
            local numentries = #v.def.config
            if numentries == 0 then
                entry.config = {}
            else
                local conf = v.def.config[1]
                if type(conf) == "function" then
                    entry.config = {v.def.config[1]}
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
                for i = 2, #v.def.config do
                    conf = v.def.config[i]
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

local function setup_configurations(entries)
    for _, x in ipairs(entries) do
        for _, v in ipairs(x.config) do
            if type(v) == "table" then
                if v.after then
                    if not v.after.config.post then
                        v.after.config.post = {}
                    end
                    table.insert(v.after.config.post, v[1])
                elseif v.before then
                    if not v.before.config.pre then
                        v.before.config.pre = {}
                    end
                    table.insert(v.before.config.pre, v[1])
                end
            end
        end
        for i = #x.config, 2, -1 do table.remove(x.config, i) end
        if x.config[1] ~= nil and type(x.config[1]) ~= "function" then
            table.remove(x.config, 1)
        end
    end
    return entries
end

local sort = function(plugins)
    plugins = create_entries(plugins)
    local edges = {}
    local remaining = 0
    for _, v in pairs(plugins) do
        if not pairs(v.before)(v.before) then
            table.insert(edges, v)
        else
            remaining = remaining + 1
        end
    end
    local sorted = {}
    while #edges > 0 do
        local edge = table.remove(edges)
        table.insert(sorted, edge)
        for _, plug in pairs(edge.after) do
            plug.before[edge.url] = nil
            if not pairs(plug.before)(plug.before) then
                remaining = remaining - 1
                table.insert(edges, plug)
            end
        end
        edge.before = nil
        edge.after = nil
    end
    if remaining ~= 0 then error "loops detected in dependency graph" end
    for i = 1, math.floor(#sorted / 2) do
        sorted[i], sorted[#sorted - i + 1] = sorted[#sorted - i + 1], sorted[i]
    end
    return setup_configurations(sorted)
end

local plugdefs
local plugin_state

local function configure_plugin(entry)
    local configspec = entry.config
    if configspec.pre then
        for i, v in ipairs(configspec.pre) do
            local success = pcall(v, plugdefs, plugin_state)
            if not success then
                print(
                    "ERROR: an error occurred while performing plugin preconfiguration " ..
                        i .. " for " .. entry.url)
            end
        end
    end
    if configspec[1] then
        local success, err = pcall(configspec[1], plugdefs, plugin_state)
        if not success then
            print(
                "ERROR: an error occurred while performing plugin configuration for " ..
                    entry.url)
            print(err)
        end
    end
    if configspec.post then
        for i, v in ipairs(configspec.post) do
            local success = pcall(v, plugdefs, plugin_state)
            if not success then
                print(
                    "ERROR: an error occurred while performing plugin postconfiguration " ..
                        i .. " for " .. entry.url)
            end
        end
    end
end

return function(plugins)
    if plugins == nil then return plugin_state end
    plugdefs = plugins
    plugin_state = {}
    for _, x in ipairs(sort(plugins)) do
        vim.cmd("packadd " .. x.value.reponame)
        configure_plugin(x)
    end
end
