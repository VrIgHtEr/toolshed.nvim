local gps = nil

local function get_location()
    return gps.get_location()
end

local function is_available()
    if not gps then
        local success
        success, gps = pcall(require, 'nvim-gps')
        print(vim.inspect(success))
        print(vim.inspect(gps))
        if not success then
            gps = nil
            return false
        end
    end
    return gps.is_available()
end

return {
    needs = { 'nvim-treesitter/nvim-treesitter' },
    after = { 'nvim-treesitter/nvim-treesitter', 'nvim-lualine/lualine.nvim' },
    config = {
        function()
            require('nvim-gps').setup()
        end,
        {
            function()
                local config = require('toolshed.plugtool').state 'nvim-lualine/lualine.nvim'
                if config.sections == nil then
                    config.sections = {}
                end
                if config.sections.lualine_c == nil then
                    config.sections.lualine_c = {}
                end
                table.insert(config.sections.lualine_c, { get_location, cond = is_available })
            end,
            before = 'nvim-lualine/lualine.nvim',
        },
    },
}
