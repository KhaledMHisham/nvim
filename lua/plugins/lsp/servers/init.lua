local M = {}

function M.setup(capabilities)
    require("mason").setup()
    require("mason-lspconfig").setup({
        ensure_installed = {
            "lua_ls",
            "rust_analyzer"
        },
        handlers = {
            function(server_name) -- default handler (optional)
                require("lspconfig")[server_name].setup {
                    capabilities = capabilities
                }
            end,
            ["rust_analyzer"] = function()
                require("plugins.lsp.servers.rust_lsp").setup(capabilities)
            end,
            ["lua_ls"] = function()
                require("plugins.lsp.servers.lua_lsp").setup(capabilities)
            end,
        }
    })
end

return M
