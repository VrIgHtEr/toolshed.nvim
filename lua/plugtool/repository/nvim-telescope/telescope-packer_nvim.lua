return {
    plugin_type = require('plugtool.constants').type.gui,
    needs = { 'wbthomason/packer.nvim', 'nvim-telescope/telescope.nvim' },
    after = { 'wbthomason/packer.nvim' },
    config = function()
        require('telescope').load_extension 'packer'
    end,
}
