return {
    config = function(_, state)
        vim.o.completeopt = 'menu,menuone,noselect'
        local cmp = require 'cmp'

        if state['hrsh7th/nvim-cmp'] == nil then
            state['hrsh7th/nvim-cmp'] = {}
        end
        state = state['hrsh7th/nvim-cmp']
        local sources = {}
        if state.nvim_lsp then
            table.insert(sources, { name = 'nvim_lsp' })
        end
        if state.vsnip then
            table.insert(sources, { name = 'vsnip' })
        end
        sources = { sources }
        if state.path then
            table.insert(sources, { { name = 'path' } })
        end
        if state.buffer then
            table.insert(sources, { { name = 'buffer' } })
        end
        cmp.setup {
            snippet = state.snippet,
            mapping = cmp.mapping.preset.insert {
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<C-e>'] = cmp.mapping.abort(),
                ['<CR>'] = cmp.mapping.confirm { select = true }, -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            },
            sources = cmp.config.sources(unpack(sources)),
        }
        if state.cmdline then
            if state.buffer then
                cmp.setup.cmdline({ '/', '?' }, {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = {
                        { name = 'buffer' },
                    },
                })
            end

            sources = {}
            if state.path then
                table.insert(sources, { { name = 'path' } })
            end
            table.insert(sources, { { name = 'cmdline' } })
            cmp.setup.cmdline(':', { mapping = cmp.mapping.preset.cmdline(), sources = cmp.config.sources(unpack(sources)) })
        end
        if state.nvim_lsp then
            state.capabilities = require('cmp_nvim_lsp').default_capabilities()
        end
    end,
}
