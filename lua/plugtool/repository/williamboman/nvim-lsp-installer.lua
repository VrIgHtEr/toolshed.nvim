return {
    needs = { 'neovim/nvim-lspconfig' },
    after = { 'neovim/nvim-lspconfig' },
    config = function()
        local lsp_installer = require 'nvim-lsp-installer'
        lsp_installer.settings {
            ui = {
                icons = {
                    -- The list icon to use for installed servers.
                    server_installed = '◍',
                    -- The list icon to use for servers that are pending installation.
                    server_pending = '◍',
                    -- The list icon to use for servers that are not installed.
                    server_uninstalled = '◍',
                },
                keymaps = {
                    -- Keymap to expand a server in the UI
                    toggle_server_expand = '<CR>',
                    -- Keymap to install a server
                    install_server = 'i',
                    -- Keymap to reinstall/update a server
                    update_server = 'u',
                    -- Keymap to uninstall a server
                    uninstall_server = 'X',
                },
            },

            -- The directory in which to install all servers.
            install_root_dir = table.concat({ require('toolshed.env').opt, 'lsp' }, '/'),

            pip = {
                -- These args will be added to `pip install` calls. Note that setting extra args might impact intended behavior
                -- and is not recommended.
                --
                -- Example: { "--proxy", "https://proxyserver" }
                install_args = {},
            },

            -- Controls to which degree logs are written to the log file. It's useful to set this to vim.log.levels.DEBUG when
            -- debugging issues with server installations.
            log_level = vim.log.levels.INFO,

            -- Limit for the maximum amount of servers to be installed at the same time. Once this limit is reached, any further
            -- servers that are requested to be installed will be put in a queue.
            max_concurrent_installers = 4,
        }
        for _, server in ipairs(lsp_installer.get_installed_servers()) do
            local hasOpts, opts = pcall(require, 'cfg/lsp/' .. server.name)
            if not hasOpts then
                opts = {}
            else
                if type(opts) ~= 'table' then
                    error("ERROR :: LSP config :: expected 'table' but got '" .. type(opts) .. "' instead")
                end
            end
            if opts.on_attach ~= nil then
                if type(opts.on_attach) ~= 'function' then
                    error 'lsp on_attach is not a function'
                end
                local on_attach = opts.on_attach
                on_attach = function(...)
                    require('nvim-navic').attach(...)
                    on_attach(...)
                end
            else
                opts.on_attach = require('nvim-navic').attach
            end
            require('lspconfig')[server.name].setup(opts)
        end
    end,
}
