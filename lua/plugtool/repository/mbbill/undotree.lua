return {
    plugin_type = require('plugtool.constants').type.gui,
    config = function()
        nnoremap('<leader>ut', ':UndotreeToggle<cr>', 'silent', 'Toggles the vim undo tree browser')
    end,
}
