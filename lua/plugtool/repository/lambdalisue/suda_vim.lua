return {
    preload = function()
        vim.g.suda_smart_edit = 1
        vim.g['suda#prompt'] = 'Enter password for current user: '
    end,
}
