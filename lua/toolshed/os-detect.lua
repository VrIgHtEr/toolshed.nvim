local M = {}

M.is_linux = 0
M.is_macos = 0
M.is_windows = 0

if vim.fn.has("mac") == 1 then
    M.is_macos = 1
    M.system_name = "macos"
elseif vim.fn.has("unix") == 1 then
    M.is_linux = 1
    M.system_name = "linux"
elseif vim.fn.has('win32') == 1 then
    M.is_windows = 1
    M.system_name = "windows"
else
    M.system_name = 'unknown'
end
return M

