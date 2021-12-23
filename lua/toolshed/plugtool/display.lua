local display = {}
function display.new()
    vim.cmd('vsplit')
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(win, buf)
    local maxline = 0
    local plugins = {}

    local function make_displayer(url)
        maxline = maxline + 1
        local line = tostring(maxline)
        while #line < 3 do line = ' ' .. line end
        return function(str)
            vim.schedule(function()
                print("DISPLAYER " .. line .. ": " .. url .. ': ' .. str)
            end)
        end
    end

    return {
        close = function() vim.api.nvim_buf_delete(buf, {force = true}) end,
        displayer = function(url)
            if not plugins[url] then
                plugins[url] = make_displayer(url)
            end
            return plugins[url]
        end
    }
end
return display
