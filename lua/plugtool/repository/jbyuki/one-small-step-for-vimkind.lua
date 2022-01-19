return {
    needs = { 'mfussenegger/nvim-dap', 'b0o/mapx.nvim' },
    after = {
        'mfussenegger/nvim-dap',
        'b0o/mapx.nvim',
    },
    config = function()
        nnoremap('<leader>rl', ':lua require"osv".run_this()<cr>', 'silent', 'Lua: Debug the current file')
    end,
}
