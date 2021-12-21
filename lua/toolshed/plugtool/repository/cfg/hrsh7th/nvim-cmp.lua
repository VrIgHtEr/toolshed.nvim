return function(plugs, state)
    vim.o.completeopt = "menu,menuone,noselect"
    local cmp = require 'cmp'

    if state['hrsh7th/nvim-cmp'] == nil then state['hrsh7th/nvim-cmp'] = {} end
    state = state['hrsh7th/nvim-cmp']
    local sources = {}
    if state.nvim_lsp then
        require('cmp_nvim_lsp').setup()
        table.insert(sources, {name = 'nvim_lsp'})
    end
    if state.vsnip then
        require'cmp'.register_source('vsnip', require'cmp_vsnip'.new())
        table.insert(sources, {name = 'vsnip'})
    end
    if state.buffer then
        require('cmp').register_source('buffer', require('cmp_buffer'))
        table.insert(sources, {name = 'buffer'})
    end
    if state.cmdline then
        require('cmp').register_source('cmdline', require('cmp_cmdline').new())
    end
    if state.path then
        require('cmp').register_source('path', require('cmp_path').new())
        table.insert(sources, {name = 'path'})
    end
    local snippet = {}
    if state.vsnip then
        snippet.expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end
    end
    cmp.setup({
        snippet = snippet,
        mapping = {
            ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i', 'c'}),
            ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i', 'c'}),
            ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
            ['<C-y>'] = cmp.config.disable,
            ['<C-e>'] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close()
            }),
            ['<CR>'] = cmp.mapping.confirm({select = true})
        },
        sources = cmp.config.sources(sources)
    })
    if state.cmdline then
        sources = {}
        if state.buffer then table.insert(sources, {name = 'buffer'}) end
        cmp.setup.cmdline('/', {sources = sources})

        sources = {{name = "cmdline"}}
        if state.path then table.insert(sources, {name = 'path'}) end
        cmp.setup.cmdline(':', {sources = cmp.config.sources(sources)})
    end
    if state.nvim_lsp then
        state.capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp
                                                                             .protocol
                                                                             .make_client_capabilities())
    end
end
