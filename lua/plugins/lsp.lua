return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
        "j-hui/fidget.nvim"
    },

    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                rust = { "rustfmt", lsp_format = "fallback" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_format = "fallback",
            },
        })
        require("fidget").setup({})

        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer"
            },
            handlers = {
                function(server_name)     -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,
                ["rust_analyzer"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.rust_analyzer.setup {
                        capabilities = capabilities,
                        on_attach = function(client, bufnr)
                            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

                            local keymap_opts = { buffer = bufnr }

                            -- Code navigation and shortcuts
                            vim.keymap.set("n", "gd", vim.lsp.buf.definition, keymap_opts)
                            vim.keymap.set("n", "gD", vim.lsp.buf.implementation, keymap_opts)
                            vim.keymap.set("n", "td", vim.lsp.buf.type_definition, keymap_opts)
                            vim.keymap.set("n", "K", vim.lsp.buf.hover, keymap_opts)
                            vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, keymap_opts)
                            vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, keymap_opts)
                            vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, keymap_opts)
                            vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, keymap_opts)
                            vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, keymap_opts)

                            -- Set updatetime for CursorHold
                            -- 300ms of no cursor movement to trigger CursorHold
                            vim.opt.updatetime = 100

                            -- Show diagnostic popup on cursor hover
                            local diag_float_grp = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })
                            vim.api.nvim_create_autocmd("CursorHold", {
                                callback = function()
                                    vim.diagnostic.open_float(nil, { focusable = false })
                                end,
                                group = diag_float_grp,
                            })

                            -- Goto previous/next diagnostic warning/error
                            vim.keymap.set("n", "g[", vim.diagnostic.goto_prev, keymap_opts)
                            vim.keymap.set("n", "g]", vim.diagnostic.goto_next, keymap_opts)
                        end,
                        settings = {
                            ["rust-analyzer"] = {
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
                        }
                    }
                end,
                ["lua_ls"] = function()
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
                end,
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)     -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = "copilot", group_index = 2 },
                { name = 'nvim_lsp' },
                { name = 'luasnip' },     -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
