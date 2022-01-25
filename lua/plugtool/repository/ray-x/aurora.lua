return {
    plugin_type = require('plugtool.constants').type.theme,
    preload = function()
        vim.o.termguicolors = true
    end,
    config = function()
        vim.api.nvim_exec('colorscheme aurora', true)
    end,
}
