local env = require 'toolshed.env'
local a = require 'toolshed.async'
local dirname = 'eclipse.jdt.ls'

local function check_java_dependency(...)
    local versions = {...}
    return function()
        local firstline
        local ret = a.spawn_lines_a({"java", "--version"}, function(line)
            if not firstline then firstline = line end
        end)
        if ret ~= 0 then return "java " .. table.concat(versions, ".") end
        local gm = firstline:gmatch '(%d+)'
        for _, x in ipairs(versions) do
            local num = gm()
            if not num or tonumber(num) ~= x then
                return "java " .. table.concat(versions, '.')
            end
        end
    end
end

local function install_dependencies()
    return env.install_dependencies({
        {
            dirname = dirname,
            repo = 'https://github.com/eclipse/eclipse.jdt.ls.git',
            builddeps = {check_java_dependency(11)},
            buildcmd = {{'./mvnw', 'clean', 'verify', '-DskipTests=true'}},
            launchscript = {
                name = "jdtls",
                script = [[#!/bin/env sh
dir=]] .. env.bashescape(env.get_dependency_path(dirname) ..
                             "/org.eclipse.jdt.ls.product/target/repository") ..
                    [[
 
if ! [ -z $dir ] ; then
    java \
    -Declipse.application=org.eclipse.jdt.ls.core.id1 \
    -Dosgi.bundles.defaultStartLevel=4 \
    -Declipse.product=org.eclipse.jdt.ls.core.product \
    -Dlog.level=ALL \
    -noverify \
    -Xmx1G \
    -jar $dir/plugins/org.eclipse.equinox.launcher_*.jar \
    -configuration $dir/config_linux \
    -data ${1:-$HOME/code/java/.workspace} \
    --add-modules=ALL-SYSTEM \
    --add-opens java.base/java.util=ALL-UNNAMED \
    --add-opens java.base/java.lang=ALL-UNNAMED
fi
]]
            }
        }, {
            dirname = 'java-debug',
            repo = 'https://github.com/microsoft/java-debug.git',
            buildcmd = {{'./mvnw', 'clean', 'install'}},
            builddeps = {check_java_dependency(11)}
        }, {
            dirname = 'vscode-java-test',
            repo = 'https://github.com/microsoft/vscode-java-test.git',
            buildcmd = {{'npm', 'install'}, {'npm', 'run', 'build-plugin'}},
            builddeps = {check_java_dependency(11), env.exec_checker('npm')}
        }
    })
end

local function setup(state)
    local pworkspace = env.var .. "/jdtls/workspace"

    local bund = {
        vim.fn.glob(env.opt ..
                        "/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar")
    }
    vim.list_extend(bund, vim.split(
                        vim.fn.glob(env.opt .. "/vscode-java-test/server/*.jar"),
                        "\n"))
    local projectroot = require'jdtls.setup'.find_root({
        'gradle.build', 'pom.xml'
    })
    local config = {}
    config['cmd'] = {
        'jdtls', pworkspace .. '/' .. vim.fn.fnamemodify('.', ":p:h:t")
    }
    config['root_dir'] = projectroot
    config['init_options'] = {bundles = bund}
    config.settings = {
        java = {
            configuration = {
                runtimes = {
                    {name = "JavaSE-1.8", path = "/usr/lib/jvm/java-8-openjdk/"},
                    {name = "JavaSE-11", path = "/usr/lib/jvm/java-11-openjdk/"},
                    {name = "JavaSE-17", path = "/usr/lib/jvm/java-17-openjdk/"}
                }
            }
        }
    }
    config['on_attach'] = function(_, _)
        require'jdtls'.setup_dap({hotcodereplace = 'auto'})
        require'jdtls.setup'.add_commands()

        local finders = require 'telescope.finders'
        local sorters = require 'telescope.sorters'
        local actions = require 'telescope.actions'
        local pickers = require 'telescope.pickers'
        local action_state = require 'telescope.actions.state'
        require('jdtls.ui').pick_one_async =
            function(items, prompt, label_fn, cb)
                local opts = {}
                pickers.new(opts, {
                    prompt_title = prompt,
                    finder = finders.new_table {
                        results = items,
                        entry_maker = function(entry)
                            return {
                                value = entry,
                                display = label_fn(entry),
                                ordinal = label_fn(entry)
                            }
                        end
                    },
                    sorter = sorters.get_generic_fuzzy_sorter(),
                    attach_mappings = function(prompt_bufnr)
                        actions.select_default:replace(function()
                            local selection =
                                action_state.get_selected_entry(prompt_bufnr)

                            actions.close(prompt_bufnr)

                            cb(selection.value)
                        end)

                        return true
                    end
                }):find()
            end
        vim.lsp.buf.code_action = require'jdtls'.code_action
    end
    state.setup = function() require'jdtls'.start_or_attach(config) end
    vim.api.nvim_exec([[
                            augroup NvimJdtlsFormatAutogroup
                              autocmd!
                              autocmd BufWritePre *.java lua vim.lsp.buf.formatting_sync()
                              autocmd BufRead,BufNewFile *.java lua require'toolshed.plugtool'.state"mfussenegger/nvim-jdtls".setup()
                            augroup end
                        nnoremap <buffer> <leader>cc :JdtCompile<cr>
                          ]], true)
end

return function(plugs, state)
    install_dependencies()
    setup(require'toolshed.plugtool'.state('mfussenegger/nvim-jdtls'))
end
