return {
    config = function()
        nnoremap('<leader>ldl', '<Plug>(Luadev-RunLine)<cr>', 'silent', 'Luadev: Run line')
        nnoremap('<leader>ldw', '<Plug>(Luadev-RunWord)<cr>', 'silent', 'Luadev: Evaluate identifier under the cursor')
        vnoremap('<leader>ldr', '<Plug>(Luadev-RunWord)<cr>', 'silent', 'Luadev: Run movement or text object')
    end,
}
