return {
    needs = { 'nvim-treesitter/nvim-treesitter' },
    after = { 'nvim-treesitter/nvim-treesitter', 'nvim-lualine/lualine.nvim' },
    config = function()
        local config = require('toolshed.plugtool').state 'nvim-lualine/lualine.nvim'
        if config.sections == nil then
            config.sections = {}
        end
        if config.sections.lualine_x == nil then
            config.sections.lualine_x = {}
        end
        local gps = require 'nvim-gps'
        table.insert(config.sections.lualine_x, { gps.get_location, cond = gps.is_available })
    end,
}
