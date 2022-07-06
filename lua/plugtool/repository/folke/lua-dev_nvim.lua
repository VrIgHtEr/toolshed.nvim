return {
    needs = { 'neovim/nvim-lspconfig', 'mfussenegger/nvim-dap' },
    after = { 'neovim/nvim-lspconfig', 'mfussenegger/nvim-dap', 'SmiteshP/nvim-navic' },
    config = function(plugins)
        local globals = { 'vim' }
        if plugins['b0o/mapx.nvim'] then
            for _, mode in ipairs { '', 'n', 'v', 'x', 's', 'o', 'i', 'l', 'c', 't' } do
                table.insert(globals, mode .. 'map')
                table.insert(globals, mode .. 'noremap')
            end
            table.insert(globals, 'mapbang')
            table.insert(globals, 'noremapbang')
            table.insert(globals, 'cmd')
            table.insert(globals, 'cmdbang')
        end

        local on_attach = nil
        if plugins['SmiteshP/nvim-navic'] then
            local navic = require 'nvim-navic'
            on_attach = function(client, bufnr)
                navic.attach(client, bufnr)
            end
        end

        local luadev = require('lua-dev').setup {
            library = {
                vimruntime = true, -- runtime path
                types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
                plugins = true, -- installed opt or start plugins in packpath
                -- you can also specify the list of plugins to make available as a workspace library
                -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
            },
            runtime_path = true,
            lspconfig = {
                capabilities = require('lsp/lsp').capabilities,
                cmd = { require('toolshed.env').bin .. '/lua-language-server' },
                on_attach = on_attach,
                settings = {
                    Lua = {
                        workspace = {
                            preloadFileSize = 1024,
                        },
                        diagnostics = {
                            globals = globals,
                        },
                        IntelliSense = {
                            traceLocalSet = true,
                            traceReturn = true,
                            traceBeSetted = true,
                            traceFieldInject = true,
                        },
                    },
                },
            },
        }
        local lspconfig = require 'lspconfig'
        lspconfig.sumneko_lua.setup(luadev)

        local dap = require 'dap'
        dap.configurations.lua = {
            {
                type = 'nlua',
                request = 'attach',
                name = 'Attach to running Neovim instance',
                host = function()
                    local value = vim.fn.input 'Host [127.0.0.1]: '
                    if value ~= '' then
                        return value
                    end
                    return '127.0.0.1'
                end,
                port = function()
                    local val = tonumber(vim.fn.input 'Port: ')
                    assert(val, 'Please provide a port number')
                    return val
                end,
            },
        }

        dap.adapters.nlua = function(callback, config)
            callback { type = 'server', host = config.host, port = config.port }
        end
    end,
}
