return {
    config = {
        {
            function()
                vim.api.nvim_exec(
                    [[augroup plugtoolaugroup
              autocmd!
              autocmd BufEnter plugtool :IndentBlanklineDisable
              autocmd BufLeave plugtool :IndentBlanklineEnable
              autocmd FileType plugtool :IndentBlanklineDisable
          augroup end]],
                    true
                )
            end,
            after = 'likas-reineke/indent-blankline.nvim',
        },
    },
}
