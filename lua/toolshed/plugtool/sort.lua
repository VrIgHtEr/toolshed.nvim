return function(plugdefs)
    for k, v in pairs(plugdefs) do
        if not v.neededby then v.neededby = {} end
        if v.needs ~= nil then
            for _, n in ipairs(v.needs) do
                if plugdefs[n].neededby == nil then
                    plugdefs[n].neededby = {}
                end
                table.insert(plugdefs[n].neededby, k)
            end
        end
    end
    local edges = {}
    local remaining = 0
    local sorted = {}
    for _, v in pairs(plugdefs) do
        if #v.neededby == 0 then
            table.insert(edges, v)
        else
            remaining = remaining + 1
        end
    end
    while #edges > 0 do
        local edge = table.remove(edges)
        local url = edge.username .. '/' .. edge.reponame
        table.insert(sorted, edge)
        if edge.needs then
            for _, n in ipairs(edge.needs) do
                local need = plugdefs[n]
                local index = 0
                for i, z in ipairs(need.neededby) do
                    if z == url then
                        index = i
                        break
                    end
                end
                table.remove(need.neededby, index)
                if #need.neededby == 0 then
                    remaining = remaining - 1
                    table.insert(edges, need)
                end
            end
        end
    end
    for _, v in pairs(plugdefs) do v.neededby = nil end
    if remaining ~= 0 then error "loops detected in dependency graph" end
    for i = 1, math.floor(#sorted / 2) do
        sorted[i], sorted[#sorted - i + 1] = sorted[#sorted - i + 1], sorted[i]
    end
    print "LOAD_ORDER:"
    for i, v in ipairs(sorted) do
        print(i .. ": " .. v.username .. '/' .. v.reponame)
    end
    return sorted
end
