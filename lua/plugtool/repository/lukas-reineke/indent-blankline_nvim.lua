return {
    needs = { 'nvim-treesitter/nvim-treesitter' },
    after = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
        --        vim.opt.list = true
        --        vim.opt.listchars:append 'space:⋅'
        --        vim.opt.listchars:append 'eol:↴'

        local state = require('plugtool').state 'lukas-reineke/indent-blankline.nvim'
        if state.excludedfiletypes then
            local autocmds = { 'augroup plugtool_indentblanklineexcludediletypes', 'autocmd!' }
            for _, x in ipairs(state.excludedfiletypes) do
                table.insert(autocmds, 'autocmd BufEnter ' .. x .. ' :IndentBlanklineDisable')
                table.insert(autocmds, 'autocmd BufLeave ' .. x .. ' :IndentBlanklineEnable')
                table.insert(autocmds, 'autocmd FileType ' .. x .. ' :IndentBlanklineDisable')
            end
            table.insert(autocmds, 'augroup end')
            vim.api.nvim_exec(table.concat(autocmds, '\n'), true)
        end
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
