return {
    needs = {'neovim/nvim-lspconfig', 'mfussenegger/nvim-dap'},
    after = {'neovim/nvim-lspconfig', 'mfussenegger/nvim-dap'},
    config = function()
        local runtime_path = vim.split(package.path, ';')
        table.insert(runtime_path, "lua/?.lua")
        table.insert(runtime_path, "lua/?/init.lua")

        local luadev = require("lua-dev").setup({
            library = {
                vimruntime = true, -- runtime path
                types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
                plugins = true -- installed opt or start plugins in packpath
                -- you can also specify the list of plugins to make available as a workspace library
                -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
            },
            lspconfig = {
                capabilities = require'lsp/lsp'.capabilities,
                cmd = {require'toolshed.env'.bin .. "/lua-language-server"}
            }
        })
        local lspconfig = require('lspconfig')
        lspconfig.sumneko_lua.setup(luadev)

        local dap = require "dap"
        dap.configurations.lua = {
            {
                type = 'nlua',
                request = 'attach',
                name = "Attach to running Neovim instance",
                host = function()
                    local value = vim.fn.input('Host [127.0.0.1]: ')
                    if value ~= "" then return value end
                    return '127.0.0.1'
                end,
                port = function()
                    local val = tonumber(vim.fn.input('Port: '))
                    assert(val, "Please provide a port number")
                    return val
                end
            }
        }

        dap.adapters.nlua = function(callback, config)
            callback({type = 'server', host = config.host, port = config.port})
        end

        if vim.fn.has('nvim-0.5') then
            vim.api.nvim_exec([[
            augroup lua_formatting
                au!
        autocmd FileType lua nnoremap <buffer> <c-k> :call LuaFormat()<cr>
                autocmd BufWrite *.lua call LuaFormat()
            augroup end
    ]], true)
        end
    end
}
