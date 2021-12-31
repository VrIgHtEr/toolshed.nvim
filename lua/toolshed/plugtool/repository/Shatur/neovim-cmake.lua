return {
    needs = {"mfussenegger/nvim-dap", "nvim-telescope/telescope.nvim"},
    after = {"mfussenegger/nvim-dap", "nvim-telescope/telescope.nvim"},
    config = function()
        require'telescope'.load_extension("cmake")
        require('cmake').setup({
            dap_configuration = {
                type = 'codelldb',
                request = 'launch',
                stopOnEntry = false,
                runInTerminal = false
            }
        })
        vim.api.nvim_exec([[
                            augroup NeovimCmakeFormatAutogroup
                              autocmd!
                              autocmd BufWritePre *.cpp lua vim.lsp.buf.formatting_sync()
                              autocmd BufWritePre *.hpp lua vim.lsp.buf.formatting_sync()
                              autocmd BufWritePre *.c lua vim.lsp.buf.formatting_sync()
                              autocmd BufWritePre *.h lua vim.lsp.buf.formatting_sync()
                            augroup end
                        nnoremap <buffer> <leader>cc :JdtCompile<cr>
                          ]], true)

    end
}
