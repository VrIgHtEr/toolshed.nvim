return {
    needs = { 'nvim-treesitter/nvim-treesitter' },
    after = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
        --        vim.opt.list = true
        --        vim.opt.listchars:append 'space:⋅'
        --        vim.opt.listchars:append 'eol:↴'

        require('indent_blankline').setup {
            use_treesitter = true,
            show_trailing_blankline_indent = true,
            enabled = true,
            show_end_of_line = true,
            show_foldtext = true,
            show_current_context_start = true,
            show_current_context_start_on_current_line = true,
            show_current_context = true,
            space_char_blankline = ' ',
        }
    end,
}
