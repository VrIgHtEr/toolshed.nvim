return {
    config = function()
        nnoremap('<leader>cf', ':lua vim.lsp.buf.format()<cr>', 'silent', 'Lsp: Format file')
        nnoremap('<leader>rr', ':lua vim.lsp.buf.rename()<cr>', 'silent', 'Lsp: Rename element')
        nnoremap('<leader>ca', ':lua vim.lsp.buf.code_action()<cr>', 'silent', 'Lsp: Code action')
        nnoremap('<leader>gd', ':lua vim.lsp.buf.definition()<cr>', 'silent', 'Lsp: Go to definition')
        nnoremap('<leader>ch', ':lua vim.lsp.buf.hover()<cr>', 'silent', 'Lsp: Hover')
    end,
}
