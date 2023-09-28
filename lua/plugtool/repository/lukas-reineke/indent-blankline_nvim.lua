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
                table.insert(autocmds, 'autocmd BufEnter ' .. x .. ' :IBLDisable')
                table.insert(autocmds, 'autocmd BufLeave ' .. x .. ' :IBLEnable')
                table.insert(autocmds, 'autocmd FileType ' .. x .. ' :IBLDisable')
            end
            table.insert(autocmds, 'augroup end')
            vim.api.nvim_exec(table.concat(autocmds, '\n'), true)
        end
        require('ibl').setup()
    end,
}
