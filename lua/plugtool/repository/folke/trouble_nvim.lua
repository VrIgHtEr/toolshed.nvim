return {
    needs = { 'kyazdani42/nvim-web-devicons' },
    after = { 'kyazdani42/nvim-web-devicons' },
    config = function()
        require('trouble').setup {}
    end,
}
