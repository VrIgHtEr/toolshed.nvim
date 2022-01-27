local M = {}
for k, v in pairs(vim.loop.constants) do
    if k:len() > 3 and k:sub(1, 3) == 'SIG' then
        M[k:sub(4):lower()] = v
        M[v] = k
    end
end
return M
