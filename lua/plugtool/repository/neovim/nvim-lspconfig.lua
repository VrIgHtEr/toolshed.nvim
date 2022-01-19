return {
    needs = { 'b0o/mapx.nvim' },
    after = { 'rcarriga/nvim-notify', 'b0o/mapx.nvim' },
    config = function()
        nnoremap('<leader>cf', ':lua vim.lsp.buf.formatting()<cr>', 'silent', 'Lsp: Format file')
        nnoremap('<leader>rr', ':lua vim.lsp.buf.rename()<cr>', 'silent', 'Lsp: Rename element')
        nnoremap('<leader>ca', ':lua vim.lsp.buf.code_action()<cr>', 'silent', 'Lsp: Code action')
        nnoremap('<leader>gd', ':lua vim.lsp.buf.definition()<cr>', 'silent', 'Lsp: Go to definition')
        local env = require 'toolshed.env'
        local dirname = 'lua-language-server'
        local path = env.get_dependency_path(dirname)
        return env.install_dependencies {
            {
                skip = false,
                dirname = dirname,
                repo = 'https://github.com/sumneko/lua-language-server',
                recurse_submodules = true,
                buildcmd = {
                    { 'compile/install.sh', cwd = path .. '/3rd/luamake' },
                    { '3rd/luamake/luamake', 'rebuild', cwd = path },
                },
                launchscript = {
                    name = 'lua-language-server',
                    script = [[#!/bin/env sh
]] .. env.bashescape(path .. '/bin/lua-language-server') .. ' -E ' .. env.bashescape(path .. '/bin/main.lua') .. ' $@',
                },
                builddeps = { env.exec_checker 'ninja' },
            },
        }
    end,
}
