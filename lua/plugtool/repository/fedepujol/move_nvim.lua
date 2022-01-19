return {
    needs = { 'b0o/mapx.nvim' },
    after = { 'b0o/mapx.nvim' },
    config = function()
        _G['nnoremap']('<A-j>', ':MoveLine(1)<CR>', 'silent', 'Move line down')
        _G['nnoremap']('<A-k>', ':MoveLine(-1)<CR>', 'silent', 'Move line up')
        _G['nnoremap']('<A-l>', ':MoveHChar(1)<CR>', 'silent', 'Move character to the right')
        _G['nnoremap']('<A-h>', ':MoveHChar(-1)<CR>', 'silent', 'Move character to the left')

        _G['vnoremap']('<A-j>', ':MoveBlock(1)<CR>', 'silent', 'Move block down')
        _G['vnoremap']('<A-k>', ':MoveBlock(-1)<CR>', 'silent', 'Move block up')
        _G['vnoremap']('<A-l>', ':MoveHBlock(1)<CR>', 'silent', 'Move block to the right')
        _G['vnoremap']('<A-l>', ':MoveHBlock(-1)<CR>', 'silent', 'Move block to the left')
    end,
}
