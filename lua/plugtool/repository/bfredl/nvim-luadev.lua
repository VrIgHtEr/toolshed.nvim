return {
    config = function()
        nnoremap('<leader>ldl', '<Plug>(Luadev-RunLine)', 'silent', 'Luadev: Run line')
        nnoremap('<leader>ldw', '<Plug>(Luadev-RunWord)', 'silent', 'Luadev: Evaluate identifier under the cursor')
        vnoremap('<leader>ldr', '<Plug>(Luadev-RunWord)', 'silent', 'Luadev: Run movement or text object')
    end,
}
