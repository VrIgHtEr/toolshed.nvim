return {
    plugin_type = require('plugtool.constants').type.util,
    config = function()
        nnoremap('<A-j>', ':MoveLine(1)<CR>', 'silent', 'Move line down')
        nnoremap('<A-k>', ':MoveLine(-1)<CR>', 'silent', 'Move line up')
        nnoremap('<A-l>', ':MoveHChar(1)<CR>', 'silent', 'Move character to the right')
        nnoremap('<A-h>', ':MoveHChar(-1)<CR>', 'silent', 'Move character to the left')

        vnoremap('<A-j>', ':MoveBlock(1)<CR>', 'silent', 'Move block down')
        vnoremap('<A-k>', ':MoveBlock(-1)<CR>', 'silent', 'Move block up')
        vnoremap('<A-l>', ':MoveHBlock(1)<CR>', 'silent', 'Move block to the right')
        vnoremap('<A-l>', ':MoveHBlock(-1)<CR>', 'silent', 'Move block to the left')
    end,
}
