-- Enable line numbering and set it to relative
vim.opt.number = true          -- Turn on line numbering
vim.opt.relativenumber = true  -- Make line numbers relative

vim.cmd("cnoreabbrev R Task start cmake run")
vim.cmd("cnoreabbrev B Task start cmake build_all")
vim.cmd("cnoreabbrev I Task start cmake configure")
vim.cmd("cnoreabbrev T Task set_module_param cmake target")
vim.cmd("cnoreabbrev D Task start cmake debug")

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true  -- This converts tabs to spaces.

local M = {
  lsp = {
    config = {
      clangd = {
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        cmd = {
          "clangd",
          "--fallback-style=webkit",
          -- Other command-line arguments...
        },

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
      if client.name == 'bufls' then
        client.offset_encoding = "utf-8"
      end
    end
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
        ensure_installed = { "clangd", "pyright", "lua_ls", "bashls", "neocmake", "bufls" }, -- automatically install lsp
      },
    },
    {
      "jay-babu/mason-nvim-dap.nvim",
      opts = {
        ensure_installed = { "debugpy", "cpptools" }, -- automatically install dap
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
    },
    {
      'nvim-lua/plenary.nvim'
    },
    {
      "Shatur/neovim-tasks",
      lazy = false,
      opts = function()
        local Path = require('plenary.path')
        return {
          default_params = { -- Default module parameters with which `neovim.json` will be created.
            cmake = {
                  cmd = 'cmake', -- CMake executable to use, can be changed using `:Task set_module_param cmake cmd`.
                  build_dir = tostring(Path:new('{cwd}', 'build-{os}-{build_type}')), -- Build directory. The expressions `{cwd}`, `{os}` and `{build_type}` will be expanded with the corresponding text values. Could be a function that return the path to the build directory.
                  build_type = 'Debug', -- Build type, can be changed using `:Task set_module_param cmake build_type`.
                  dap_name = 'cppdbg', -- DAP configuration name from `require('dap').configurations`. If there is no such configuration, a new one with this name as `type` will be created.
                  args = { -- Task default arguments.
                    configure = { '-D', 'CMAKE_EXPORT_COMPILE_COMMANDS=1' },
                  }
            }
          },
          save_before_run = true, -- If true, all files will be saved before executing a task.
          params_file = 'neovim.json', -- JSON file to store module and task parameters.
          quickfix = {
            pos = 'botright', -- Default quickfix position.
            height = 12, -- Default height.
          },
          dap_open_command = function() return require('dap').repl.open() end, -- Command to run after starting DAP session. You can set it to `false` if you don't want to open anything or `require('dapui').open` if you are using https://github.com/rcarriga/nvim-dap-ui
        }
    end
    }
  }
}
return M
