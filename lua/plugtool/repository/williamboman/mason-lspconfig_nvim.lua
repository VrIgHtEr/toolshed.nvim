return {
    needs = { 'neovim/nvim-lspconfig', 'williamboman/mason.nvim' },
    after = { 'williamboman/mason.nvim', 'neovim/nvim-lspconfig' },
    config = function(plugins)
        local masonlsp = require 'mason-lspconfig'
        masonlsp.setup { automatic_installation = true }
        for _, server in ipairs(masonlsp.get_installed_servers()) do
            local hasOpts, opts = pcall(require, 'cfg/lsp/' .. server)
            if not hasOpts then
                opts = {}
            else
                if type(opts) ~= 'table' then
                    error("ERROR :: LSP config :: expected 'table' but got '" .. type(opts) .. "' instead")
                end
            end
            if plugins['SmiteshP/nvim-navic'] then
                if opts.on_attach ~= nil then
                    if type(opts.on_attach) ~= 'function' then
                        error 'lsp on_attach is not a function'
                    end
                    local on_attach = opts.on_attach
                    opts.on_attach = function(...)
                        require('nvim-navic').attach(...)
                        on_attach(...)
                    end
                else
                    opts.on_attach = require('nvim-navic').attach
                end
            end
            require('lspconfig')[server].setup(opts)
        end
    end,
}
