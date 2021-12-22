local sort = function(plugs)
    local pl = {}
    for k, v in pairs(plugs) do
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
        pl[k] = entry
    end
    plugs = pl
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
    end
    local edges = {}
    local remaining = 0
    local sorted = {}
    for _, v in pairs(plugs) do
        if not pairs(v.before)(v.before) then
            table.insert(edges, v)
        else
            remaining = remaining + 1
        end
    end
    while #edges > 0 do
        local edge = table.remove(edges)
        table.insert(sorted, edge)
        local url = edge.value.username .. '/' .. edge.value.reponame
        for n in pairs(edge.after) do
            local plug = plugs[n]
            plug.before[url] = nil
            if not pairs(plug.before)(plug.before) then
                remaining = remaining - 1
                table.insert(edges, plug)
            end
        end
    end
    for _, v in pairs(plugs) do v.before = nil end
    if remaining ~= 0 then error "loops detected in dependency graph" end
    for i = 1, math.floor(#sorted / 2) do
        sorted[i], sorted[#sorted - i + 1] = sorted[#sorted - i + 1], sorted[i]
    end
    for i = 1, #sorted do sorted[i] = sorted[i].value end
    return sorted
end
return sort
