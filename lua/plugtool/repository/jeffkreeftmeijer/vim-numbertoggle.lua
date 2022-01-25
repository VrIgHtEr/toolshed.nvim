return {
    plugin_type = require('plugtool.constants').type.util,
    config = function()
        vim.api.nvim_exec('set number', true)
    end,
}
