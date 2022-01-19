return {
    config = {
        {
            function()
                nnoremap('<leader>ut', ':UndotreeToggle<cr>', 'silent', 'Toggles the vim undo tree browser')
            end,
            after = 'b0o/mapx.nvim',
        },
    },
}
