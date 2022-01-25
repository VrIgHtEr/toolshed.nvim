return {
    plugin_type = require('plugtool.constants').type.dev,
    needs = { 'mfussenegger/nvim-dap', 'nvim-lua/plenary.nvim' },
    config = {
        function()
            require('cmake').setup {
                dap_configuration = {
                    type = 'codelldb',
                    request = 'launch',
                    stopOnEntry = false,
                    runInTerminal = false,
                },
            }
            vim.api.nvim_exec(
                [[augroup NeovimCmakeFormatAutogroup
                      autocmd!
                      autocmd BufWritePre *.cpp lua vim.lsp.buf.formatting_sync()
                      autocmd BufWritePre *.hpp lua vim.lsp.buf.formatting_sync()
                      autocmd BufWritePre *.c lua vim.lsp.buf.formatting_sync()
                      autocmd BufWritePre *.h lua vim.lsp.buf.formatting_sync()
                  augroup end]],
                true
            )
            nnoremap('<leader>mc', ':CMake configure<cr>', 'silent', 'CMake: configure')
            nnoremap('<leader>md', ':CMake clean<cr>', 'silent', 'CMake: clean')
            nnoremap('<leader>mC', ':CMake clear_cache<cr>', 'silent', 'CMake: clear_cache')
            nnoremap('<leader>mb', ':CMake build<cr>', 'silent', 'CMake: build')
            nnoremap('<leader>mr', ':CMake build_and_debug<cr>', 'silent', 'CMake: build and debug')
            nnoremap('<leader>mR', ':CMake build_and_run<cr>', 'silent', 'CMake: build and run')
        end,
    },
}
