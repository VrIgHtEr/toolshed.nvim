return {
    needs = { 'mfussenegger/nvim-dap', 'nvim-lua/plenary.nvim' },
    after = { 'mfussenegger/nvim-dap', 'nvim-lua/plenary.nvim' },
    config = {
        function()
            local Path = require 'plenary.path'
            require('tasks').setup {
                default_params = { -- Default module parameters with which `neovim.json` will be created.
                    cmake = {
                        cmd = 'cmake', -- CMake executable to use, can be changed using `:Task set_module_param cmake cmd`.
                        build_dir = tostring(Path:new('{cwd}', 'build', '{os}-{build_type}')), -- Build directory. The expressions `{cwd}`, `{os}` and `{build_type}` will be expanded with the corresponding text values. Could be a function that return the path to the build directory.
                        build_type = 'Debug', -- Build type, can be changed using `:Task set_module_param cmake build_type`.
                        dap_name = 'lldb', -- DAP configuration name from `require('dap').configurations`. If there is no such configuration, a new one with this name as `type` will be created.
                        args = { -- Task default arguments.
                            configure = { '-D', 'CMAKE_EXPORT_COMPILE_COMMANDS=1', '-G', 'Ninja' },
                        },
                    },
                },
                save_before_run = true, -- If true, all files will be saved before executing a task.
                params_file = 'neovim.json', -- JSON file to store module and task parameters.
                quickfix = {
                    pos = 'botright', -- Default quickfix position.
                    height = 12, -- Default height.
                },
                dap_open_command = require('dapui').open, -- Command to run after starting DAP session. You can set it to `false` if you don't want to open anything or `require('dapui').open` if you are using https://github.com/rcarriga/nvim-dap-ui
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
            nnoremap('<leader>mc', ':Task start cmake configure<cr>', 'silent', 'CMake: configure')
            nnoremap('<leader>mb', ':Task start cmake build<cr>', 'silent', 'CMake: build')
            nnoremap('<leader>mR', ':Task start cmake debug<cr>', 'silent', 'CMake: build and debug')
            nnoremap('<leader>mr', ':Task start cmake run<cr>', 'silent', 'CMake: build and run')
        end,
    },
}
