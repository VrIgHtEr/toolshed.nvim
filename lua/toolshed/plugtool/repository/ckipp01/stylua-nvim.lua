return {
    config = function()
        if vim.fn.has('nvim-0.5') then
            vim.api.nvim_exec([[
            augroup lua_formatting
                au!
                autocmd FileType lua nnoremap <buffer> <c-k> :lua require("stylua-nvim").format_file()<cr>
                autocmd BufWrite *.lua lua require("stylua-nvim").format_file()
            augroup end
    ]], true)
        end
    end
}

