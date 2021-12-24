return {
    needs = {'wbthomason/packer.nvim', 'nvim-telescope/telescope.nvim'},
    after = {'wbthomason/packer.nvim', 'nvim-telescope/telescope.nvim'},
    config = function() require'telescope'.load_extension("packer") end
}
