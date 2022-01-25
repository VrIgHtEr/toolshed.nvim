return {
    plugin_type = require('plugtool.constants').type.gui,
    needs = { 'nvim-lua/plenary.nvim' },
    preload = function()
        vim.o.termguicolors = true
    end,
}
