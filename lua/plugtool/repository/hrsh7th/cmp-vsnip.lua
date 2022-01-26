return {
    needs = { 'hrsh7th/nvim-cmp', 'hrsh7th/vim-vsnip' },
    before = { 'hrsh7th/nvim-cmp' },
    after = { 'hrsh7th/vim-vsnip' },
    config = function(_, state)
        if not state['hrsh7th/nvim-cmp'] then
            state['hrsh7th/nvim-cmp'] = {}
        end
        state['hrsh7th/nvim-cmp']['vsnip'] = true
        if not state['hrsh7th/nvim-cmp']['snippet'] then
            state['hrsh7th/nvim-cmp']['snippet'] = {
                expand = function(args)
                    vim.fn['vsnip#anonymous'](args.body)
                end,
            }
        end
    end,
}
