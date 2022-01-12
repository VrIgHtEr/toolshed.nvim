return {
    config = function()
        if vim.fn.has 'nvim-0.5' then
            vim.api.nvim_exec(
                [[
            augroup lua_formatting
                au!
                autocmd FileType lua nnoremap <buffer> <c-k> :lua require("stylua-nvim").format_file()<cr>
                autocmd BufWrite *.lua lua require("stylua-nvim").format_file()
            augroup end
    ]],
                true
            )
        end
        local env = require 'toolshed.env'
        local a = require 'toolshed.async'
        return a.run(function()
            return env.install_dependencies {
                {
                    dirname = 'StyLua',
                    repo = 'https://github.com/JohnnyMorganz/StyLua',
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
