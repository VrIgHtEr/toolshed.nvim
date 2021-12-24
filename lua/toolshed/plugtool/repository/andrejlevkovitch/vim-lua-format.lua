return {
    needs = {"rcarriga/nvim-notify"},
    after = {"rcarriga/nvim-notify"},
    config = function()
        local env = require 'toolshed.env'
        local a = require 'toolshed.async'
        return a.run(function()
            local nproc = a.wait(env.nproc_async())
            if not nproc or nproc <= 0 then nproc = 1 end
            nproc = tostring(nproc + 1)
            return env.install_dependencies({
                {
                    dirname = 'LuaFormatter',
                    repo = 'https://github.com/Koihik/LuaFormatter.git',
                    recurse_submodules = true,
                    buildcmd = {
                        {"cmake", "-DCMAKE_INSTALL_PREFIX=" .. env.root, "."},
                        {"make", "-j" .. nproc}, {"make", "install"}
                    },
                    builddeps = {
                        env.exec_checker("cmake"), env.exec_checker("make")
                    }
                }
            })
        end)
    end
}
