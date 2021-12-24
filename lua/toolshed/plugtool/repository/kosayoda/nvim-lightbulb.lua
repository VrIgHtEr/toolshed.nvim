return {
    config = function()
        vim.cmd [[augroup nvimlightbulb
            au!
            autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
            augroup end]]
    end
}
