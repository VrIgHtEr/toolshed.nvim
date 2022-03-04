local util = require 'toolshed.util'

return function(needle, haystack)
    if type(needle) ~= 'string' then
        return util.error('needle', 'TYPE', type(needle))
    end
    if type(haystack) ~= 'string' then
        return util.error('haystack', 'TYPE', type(haystack))
    end
    if needle:len() == 0 then
        return 0
    end
    if haystack:len() < needle:len() then
        return nil
    end
end
