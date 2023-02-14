return {
    needs = { 'neovim/nvim-lspconfig', 'mfussenegger/nvim-dap' },
    before = { 'neovim/nvim-lspconfig', 'mfussenegger/nvim-dap', 'SmiteshP/nvim-navic' },
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

        require('neodev').setup()
        local lspconfig = require 'lspconfig'
        lspconfig.lua_ls.setup {
            on_attach = on_attach,
        }

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
