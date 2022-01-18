return {
    needs = { 'nvim-treesitter/nvim-treesitter' },
    before = { 'nvim-treesitter/nvim-treesitter' },
    config = {
        {
            function()
                vim.api.nvim_exec('set termguicolors', true)
                require('nvim-treesitter.configs').setup {
                    highlight = {},
                    rainbow = {
                        enable = true,
                        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
                        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
                        max_file_lines = nil, -- Do not enable for files with more than n lines, int
                        -- colors = {}, -- table of hex strings
                        -- termcolors = {} -- table of colour name strings
                    },
                }
            end,
            after = 'nvim-treesitter/nvim-treesitter',
        },
    },
}
