-- Enable line numbering and set it to relative
vim.opt.number = true          -- Turn on line numbering
vim.opt.relativenumber = true  -- Make line numbers relative

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true  -- This converts tabs to spaces.

local M = {
  lsp = {
    ["server-settings"] = {
      clangd = {
        ["fallback-style"] = {
          BasedOnStyle = "Google",
          IndentWidth = 4,
          TabWidth = 4
        }
      }
    },
    on_attach = function(client, bufnr)
      if client.config.flags then
        client.config.flags.allow_incremental_sync = true
      end
      if client.name == 'null-ls' then
        client.offset_encoding = "utf-8"
      end
      if client.name == 'clangd' then
        client.offset_encoding = "utf-8"
      end
    end,
  },
  plugins = {
    {
      "p00f/clangd_extensions.nvim", -- install lsp plugin
      init = function()
        -- load clangd extensions when clangd attaches
        local augroup = vim.api.nvim_create_augroup("clangd_extensions", { clear = true })
        vim.api.nvim_create_autocmd("LspAttach", {
          group = augroup,
          desc = "Load clangd_extensions with clangd",
          callback = function(args)
            if assert(vim.lsp.get_client_by_id(args.data.client_id)).name == "clangd" then
              require "clangd_extensions"
              -- add more `clangd` setup here as needed such as loading autocmds
              vim.api.nvim_del_augroup_by_id(augroup) -- delete auto command since it only needs to happen once
            end
          end,
        })
      end,
    },
    {
      "williamboman/mason-lspconfig.nvim",
      opts = {
        ensure_installed = { "clangd", "pyright", "lua_ls", "bashls", "neocmake" }, -- automatically install lsp
      },
    },
    {
      "jay-babu/mason-nvim-dap.nvim",
      opts = {
        ensure_installed = { "debugpy" }, -- automatically install dap
      },
    },
    {
      "nvim-neo-tree/neo-tree.nvim",
      opts = {
        event_handlers = {
          {
            event = "neo_tree_buffer_enter",
            handler = function(_)
              vim.cmd [[
                setlocal number
                setlocal relativenumber
              ]]
            end,
          }
        },
      }
    }
  }
}

return M
