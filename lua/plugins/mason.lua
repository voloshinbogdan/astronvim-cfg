-- Customize Mason plugins

---@type LazySpec
return {
  -- use mason-lspconfig to configure LSP installations
  {
    "williamboman/mason-lspconfig.nvim",
    -- overrides `require("mason-lspconfig").setup(...)`
    opts = {
      ensure_installed = { "clangd", "pyright", "lua_ls", "bashls", "neocmake", "yamlls" }, -- automatically install lsp
    },
  },
  -- use mason-null-ls to configure Formatters/Linter installation for null-ls sources
  {
    "jay-babu/mason-null-ls.nvim",
    -- overrides `require("mason-null-ls").setup(...)`
    opts = {
      ensure_installed = {
        "stylua",
        -- add more arguments for adding more null-ls sources
      },
    },
  },
  -- {
  --   "jay-babu/mason-nvim-dap.nvim",
  --   -- overrides `require("mason-nvim-dap").setup(...)`
  --   opts = {
  --     ensure_installed = { "debugpy", "cpptools", "powershell_es" }, -- automatically install dap
  --   },
  -- },
  -- {
  --   "jay-babu/mason-nvim-dap.nvim",
  --   opts = {
  --     ensure_installed = { "debugpy", "cpptools", "powershell_es" }, -- automatically install dap
  --   },
  --   init = function()
  --     local dap = require "dap"
  --
  --     dap.configurations.cpp[1]["setupCommands"] = {
  --       {
  --         text = "-enable-pretty-printing",
  --         description = "enable pretty printing",
  --         ignoreFailures = false,
  --       },
  --     }
  --     dap.configurations.cpp[2]["setupCommands"] = {
  --       {
  --         text = "-enable-pretty-printing",
  --         description = "enable pretty printing",
  --         ignoreFailures = false,
  --       },
  --     }
  --
  --     ---@diagnostic disable-next-line: missing-fields
  --     dap.configurations.cppdbg = {
  --       type = "cppdbg",
  --       setupCommands = {
  --         {
  --           text = "-enable-pretty-printing",
  --           description = "enable pretty printing",
  --           ignoreFailures = false,
  --         },
  --       },
  --     }
  --   end,
  -- },
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      ensure_installed = { "cpptools" }, -- Ensure cpptools is installed
    },
  },
}
