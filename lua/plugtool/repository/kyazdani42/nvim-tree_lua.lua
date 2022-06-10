return {
    needs = { 'kyazdani42/nvim-web-devicons' },
    after = { 'kyazdani42/nvim-web-devicons' },
    preload = function()
        vim.o.termguicolors = true
    end,
    config = function(plugins)
        vim.api.nvim_exec(
            [[
set termguicolors " this variable must be enabled for colors to be applied properly

" a list of groups can be found at `:help nvim_tree_highlight`
highlight NvimTreeFolderIcon guibg=blue

]],
            true
        )
        if plugins['sidebar-nvim/sidebar.nvim'] then
            nnoremap('<C-n>', ':SidebarNvimClose<cr>:NvimTreeToggle<cr>', 'silent', 'Tree: Toggle file tree')
        else
            nnoremap('<C-n>', ':NvimTreeToggle<cr>', 'silent', 'Tree: Toggle file tree')
        end
        return require('nvim-tree').setup {
            disable_netrw = true,
            hijack_netrw = true,
            open_on_setup = false,
            open_on_tab = false,
            ignore_ft_on_setup = {},
            hijack_cursor = false,
            update_cwd = false,
            update_to_buf_dir = { enable = true, auto_open = true },
            git = { ignore = true },
            diagnostics = {
                enable = true,
                icons = {
                    hint = '',
                    info = '',
                    warning = '',
                    error = '',
                },
            },
            update_focused_file = {
                enable = true,
                update_cwd = false,
                ignore_list = {},
            },
            system_open = { cmd = nil, args = {} },
            filters = { dotfiles = true, custom = {} },
            view = {
                width = 30,
                height = 30,
                hide_root_folder = false,
                side = 'left',
                auto_resize = false,
                mappings = { custom_only = false, list = {} },
            },
            renderer = {
                root_folder_modifier = ':~',
                add_trailing = true,
                highlight_opened_files = 'icon',
                highlight_git = true,
                group_empty = true,
                icons = {
                    padding = ' ',
                    symlink_arrow = ' -> ',
                    show = {
                        git = true,
                        folder = true,
                        file = true,
                        folder_arrow = true,
                    },
                    glyphs = {
                        default = '',
                        symlink = '',
                        git = {
                            unstaged = '✗',
                            staged = '✓',
                            unmerged = '',
                            renamed = '➜',
                            untracked = '★',
                            deleted = '',
                            ignored = '◌',
                        },
                        folder = {
                            arrow_open = '',
                            arrow_closed = '',
                            default = '',
                            open = '',
                            empty = '',
                            empty_open = '',
                            symlink = '',
                            symlink_open = '',
                        },
                    },
                },
                special_files = { 'README.md', 'Makefile', 'MAKEFILE' },
            },
            actions = {
                open_file = {
                    quit_on_open = true,
                    window_picker = {
                        exclude = {
                            filetype = {
                                'notify',
                                'packer',
                                'qf',
                            },
                            buftype = {
                                'terminal',
                            },
                        },
                    },
                },
            },
        }
    end,
}
