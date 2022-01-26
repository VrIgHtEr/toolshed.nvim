return {
    config = function()
        nnoremap('<F5>', ':lua require"dap".continue()<cr>', 'silent', 'Dap: continue')
        nnoremap('<F10>', ':lua require"dap".step_over()<cr>', 'silent', 'Dap: Step over')
        nnoremap('<F11>', ':lua require"dap".step_into()<cr>', 'silent', 'Dap: Step into')
        nnoremap('<F12>', ':lua require"dap".step_out()<cr>', 'silent', 'Dap: Step out')
        nnoremap('<leader>b', ':lua require"dap".toggle_breakpoint()<cr>', 'silent', 'Dap: Toggle breakpoint')
        nnoremap('<leader>B', ':lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<cr>', 'silent', 'Dap: Set conditional breakpoint')
        nnoremap('<leader>dr', ':lua require"dap".repl_open()<cr>', 'silent', 'Dap: Open REPL')
        nnoremap('<leader>dl', ':lua require"dap".run_last()<cr>', 'silent', 'Dap: run last')
    end,
}
