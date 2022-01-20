return {
    needs = { 'mfussenegger/nvim-dap' },
    after = { 'mfussenegger/nvim-dap' },
    config = {
        {
            function()
                nnoremap('<leader>rl', ':lua require"osv".run_this()<cr>', 'silent', 'Lua: Debug the current file')
            end,
            after = require('plugtool.constants').mapx,
        },
    },
}
