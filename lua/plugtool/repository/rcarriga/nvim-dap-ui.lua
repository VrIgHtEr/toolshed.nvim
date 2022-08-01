return {
    needs = { 'mfussenegger/nvim-dap' },
    after = { 'mfussenegger/nvim-dap' },
    config = function()
        local dap = require 'dap'
        local dapui = require 'dapui'
        dapui.setup {
            icons = { expanded = '▾', collapsed = '▸' },
            mappings = {
                -- Use a table to apply multiple mappings
                expand = { '<CR>', '<2-LeftMouse>' },
                open = 'o',
                remove = 'd',
                edit = 'e',
                repl = 'r',
            },
            layouts = {
                {
                    elements = {
                        'scopes',
                        'breakpoints',
                        'stacks',
                        'watches',
                    },
                    size = 40,
                    position = 'left',
                },
                {
                    elements = {
                        'repl',
                        'console',
                    },
                    size = 10,
                    position = 'bottom',
                },
            },
            floating = {
                max_height = nil, -- These can be integers or a float between 0 and 1.
                max_width = nil, -- Floats will be treated as percentage of your screen.
                border = 'single', -- Border style. Can be "single", "double" or "rounded"
                mappings = { close = { 'q', '<Esc>' } },
            },
            windows = { indent = 1 },
        }

        dap.listeners.after.event_initialized['dapui_config'] = function()
            dapui.open()
        end
        dap.listeners.after.event_terminated['dapui_config'] = function()
            dapui.close()
        end
        dap.listeners.after.event_exited['dapui_config'] = function()
            dapui.close()
        end

        nnoremap('<leader>dt', ':lua require"dapui".toggle()<cr>', 'silent', 'Dap: Toggle the debugger UI')
    end,
}
