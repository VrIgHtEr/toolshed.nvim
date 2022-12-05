return {
    needs = { 'mfussenegger/nvim-dap', 'nvim-lua/plenary.nvim' },
    after = { 'mfussenegger/nvim-dap', 'nvim-lua/plenary.nvim' },
    config = {
        function()
            require('cmake-tools').setup {
                cmake_command = 'cmake',
                cmake_build_directory = 'build',
                cmake_generate_options = { '-D', 'CMAKE_EXPORT_COMPILE_COMMANDS=1' },
                cmake_build_options = {},
                cmake_console_size = 10, -- cmake output window height
                cmake_show_console = 'always', -- "always", "only_on_error"
                cmake_dap_configuration = { name = 'cpp', type = 'codelldb', request = 'launch' }, -- dap configuration, optional
                cmake_dap_open_command = require('dap').repl.open, -- optional
                cmake_variants_message = {
                    short = { show = true },
                    long = { show = true, max_length = 40 },
                },
            }
            vim.api.nvim_exec(
                [[augroup NeovimCmakeFormatAutogroup
                      autocmd!
                      autocmd BufWritePre *.zig lua (vim.lsp.buf.format or vim.lsp.buf.formatting_sync)()
                      autocmd BufWritePre *.cpp lua (vim.lsp.buf.format or vim.lsp.buf.formatting_sync)()
                      autocmd BufWritePre *.hpp lua (vim.lsp.buf.format or vim.lsp.buf.formatting_sync)()
                      autocmd BufWritePre *.c lua (vim.lsp.buf.format or vim.lsp.buf.formatting_sync)()
                      autocmd BufWritePre *.h lua (vim.lsp.buf.format or vim.lsp.buf.formatting_sync)()
                  augroup end]],
                true
            )
            nnoremap('<leader>mc', ':CMakeGenerate<cr>', 'silent', 'CMake: configure')
            nnoremap('<leader>mC', ':CMakeClean<cr>', 'silent', 'CMake: clean')
            nnoremap('<leader>mb', ':CMakeBuild<cr>', 'silent', 'CMake: build')
            nnoremap('<leader>mR', ':CMakeDebug<cr>', 'silent', 'CMake: debug')
            nnoremap('<leader>mr', ':CMakeRun<cr>', 'silent', 'CMake: run')
        end,
    },
}
