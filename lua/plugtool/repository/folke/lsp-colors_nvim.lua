return {
    plugin_type = require('plugtool.constants').type.gui,
    config = function()
        require('lsp-colors').setup {
            Error = '#db4b4b',
            Warning = '#e0af68',
            Information = '#0db9d7',
            Hint = '#10B981',
        }
    end,
    preload = function()
        vim.o.termguicolors = true
    end,
}
