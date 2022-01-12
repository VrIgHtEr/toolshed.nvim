return {
    after = { 'rcarriga/nvim-notify' },
    config = function()
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
