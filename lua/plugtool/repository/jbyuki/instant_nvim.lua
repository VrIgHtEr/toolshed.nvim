return {
    preload = function()
        local defined_username = _G['instant-username']
        if type(defined_username) ~= 'string' then
            defined_username = 'Anonymous'
        end
        vim.g.instant_username = defined_username
    end,
}
