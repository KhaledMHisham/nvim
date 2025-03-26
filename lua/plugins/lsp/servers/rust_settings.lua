local M = {}

function M.get_settings()
    return {
        imports = {
            granularity = {
                group = "module",
            },
            prefix = "self",
        },
        cargo = {
            buildScripts = {
                enable = true,
            },
        },
        procMacro = {
            enable = true
        },
        checkOnSave = {
            command = "clippy",
        },
    }
end

return M
