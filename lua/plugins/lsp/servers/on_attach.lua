local M = {}

function M.rust_setup(bufnr)
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
end

return M
