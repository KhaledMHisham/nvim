local M = {}

function M.setup(capabilities)
    local lspconfig = require("lspconfig")
    lspconfig.lua_ls.setup {
        capabilities = capabilities,
        settings = {
            Lua = {
                runtime = { version = "Lua 5.1" },
                diagnostics = {
                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                }
            }
        }
    }
end

return M
