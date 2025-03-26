local M = {}

local rust_settings = require("plugins.lsp.servers.rust_settings")
local rust_on_attach = require("plugins.lsp.servers.on_attach")

function M.setup(capabilities)
    local lspconfig = require("lspconfig")
    lspconfig.rust_analyzer.setup {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
            rust_on_attach.rust_setup(bufnr)
       end,
        settings = {
            ["rust-analyzer"] = rust_settings.get_settings()
        }
    }
end

return M
