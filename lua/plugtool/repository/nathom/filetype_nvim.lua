return {
    plugin_type = require('plugtool.constants').type.global,
    preload = function()
        vim.g.did_load_filetypes = 1
    end,
}
