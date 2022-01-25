return {
    plugin_type = require('plugtool.constants').type.dev,
    needs = { 'mfussenegger/nvim-dap' },
    config = function()
        nnoremap('<leader>rl', ':lua require"osv".run_this()<cr>', 'silent', 'Lua: Debug the current file')
    end,
}
