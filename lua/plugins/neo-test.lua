return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "antoinemadec/FixCursorHold.nvim",
        "rouge8/neotest-rust",
    },
    config = function()
        require("neotest").setup({
            adapters = {
                require("neotest-rust")({
                    -- Optional settings
                    args = { "--no-capture" }, -- To see test outputs in real-time
                    dap_adapter = "cppdbg",    -- Match your existing DAP configuration
                })
            },
        })

        -- Key mappings
        vim.keymap.set("n", "<leader>tr", function()
            require("neotest").run.run({
                suite = false,
                testify = true,
            })
        end, { desc = "Debug: Running Nearest Test" })

        vim.keymap.set("n", "<leader>tv", function()
            require("neotest").summary.toggle()
        end, { desc = "Debug: Summary Toggle" })

        vim.keymap.set("n", "<leader>ts", function()
            require("neotest").run.run({
                suite = true,
                testify = true,
            })
        end, { desc = "Debug: Running Test Suite" })

        vim.keymap.set("n", "<leader>td", function()
            require("neotest").run.run({
                suite = false,
                testify = true,
                strategy = "dap",
            })
        end, { desc = "Debug: Debug Nearest Test" })

        vim.keymap.set("n", "<leader>to", function()
            require("neotest").output.open()
        end, { desc = "Debug: Open test output" })

        vim.keymap.set("n", "<leader>ta", function()
            require("neotest").run.run(vim.fn.getcwd())
        end, { desc = "Debug: Open test output" })
    end
}
