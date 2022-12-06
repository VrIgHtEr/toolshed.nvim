local function lldb_available()
    return '/usr/bin/lldb-vscode'
end

return {
    config = function()
        nnoremap('<F5>', ':lua require"dap".continue()<cr>', 'silent', 'Dap: continue')
        nnoremap('<F10>', ':lua require"dap".step_over()<cr>', 'silent', 'Dap: Step over')
        nnoremap('<F11>', ':lua require"dap".step_into()<cr>', 'silent', 'Dap: Step into')
        nnoremap('<F12>', ':lua require"dap".step_out()<cr>', 'silent', 'Dap: Step out')
        nnoremap('<leader>db', ':lua require"dap".toggle_breakpoint()<cr>', 'silent', 'Dap: Toggle breakpoint')
        nnoremap('<leader>dB', ':lua require"dap".set_breakpoint(vim.fn.input("Breakpoint condition: "))<cr>', 'silent', 'Dap: Set conditional breakpoint')
        nnoremap('<leader>dr', ':lua require"dap".repl_open()<cr>', 'silent', 'Dap: Open REPL')
        nnoremap('<leader>dl', ':lua require"dap".run_last()<cr>', 'silent', 'Dap: run last')

        local lldbpath = lldb_available()
        if lldbpath then
            local dap = require 'dap'
            dap.adapters.lldb = {
                type = 'executable',
                command = '/usr/bin/lldb-vscode',
                name = 'lldb',
            }

            dap.configurations.cpp = {
                {
                    name = 'Launch',
                    type = 'lldb',
                    request = 'launch',
                    cwd = '${workspaceFolder}',
                    stopOnEntry = false,
                    args = {},
                },
            }
            dap.configurations.c = dap.configurations.cpp
            dap.configurations.rust = dap.configurations.cpp
            dap.configurations.zig = dap.configurations.cpp
        end
    end,
}
