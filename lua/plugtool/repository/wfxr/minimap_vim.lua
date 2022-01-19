return {
    config = function()
        vim.g.minimap_width = 10
        vim.g.minimap_auto_start = 1
        vim.g.minimap_auto_start_win_enter = 1
        local env = require 'toolshed.env'
        return require('toolshed.async').run(function()
            return env.install_dependencies {
                {
                    dirname = 'code-minimap',
                    repo = 'https://github.com/wfxr/code-minimap',
                    recurse_submodules = true,
                    buildcmd = {
                        { 'cargo', 'install', '--all-features', '--path', '.', '--root', env.root },
                    },
                    builddeps = {
                        env.exec_checker 'cargo',
                    },
                },
            }
        end)
    end,
}
