return {
    config = function()
        local impatient = require 'impatient'
        if require('plugtool').flag 'profile_lua_cache' then
            impatient.enable_profile()
        end
    end,
}
