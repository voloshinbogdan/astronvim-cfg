function Dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. Dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.template",
    command = "call jinja#AdjustCompoundFiletype(expand('<afile>'))"
})

vim.opt.scrolloff = 8

function ToggleQuickfix()
  local quickfix_open = false
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      quickfix_open = true
      break
    end
  end
  if quickfix_open then
    vim.cmd('cclose')
  else
    vim.cmd('copen')
  end
end



local M = {
  mappings = {
    -- first key is the mode
    n = {
      -- second key is the lefthand side of the map
      -- mappings seen under group name "Buffer"
      ["<Leader>fT"] = { "<cmd>TodoTelescope<cr>", desc = "Find Todo" },
      ["<Leader>r"] = { desc = "󱌣 Build"},
      ["<Leader>rq"] = { "<cmd>lua ToggleQuickfix()<cr>", desc = "Toggle Quickfix" },
      ["<Leader>rr"] = { "<cmd>Task start cmake run<cr>", desc = "Run"},
      ["<Leader>rb"] = { "<cmd>Task start cmake build_all<cr>", desc = "Build All"},
      ["<Leader>ri"] = { "<cmd>Task start cmake configure<cr>", desc = "Default init"},
      ["<Leader>rt"] = { "<cmd>Task set_module_param cmake target<cr>", desc = "Target"},
      ["<Leader>rd"] = { "<cmd>Task start cmake debug<cr>", desc = "Debug"},
      ["<Leader>rx"] = { "<cmd>Task cancel<cr>", desc = "Cancel"}
    }
  },
  options = {
    opt = {
      -- set to true or false etc.
      relativenumber = true, -- sets vim.opt.relativenumber
      number = true, -- sets vim.opt.number
      shiftwidth = 4,
      tabstop = 4,
      colorcolumn = "80"
    }
  },

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
      "m00qek/baleia.nvim",
      lazy = false,
      version = "*",
      config = function()
        vim.g.baleia = require("baleia").setup({})
        vim.api.nvim_create_autocmd({ "BufReadPost" }, {
          pattern = "quickfix",
          callback = function()
            local buffer = vim.api.nvim_get_current_buf()
            vim.api.nvim_set_option_value("modifiable", true, { buf = buffer })
            vim.g.baleia.once(buffer)
            vim.api.nvim_set_option_value("modified", false, { buf = buffer })
            vim.api.nvim_set_option_value("modifiable", false, { buf = buffer })
          end,
        })
      end
      
    },
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
        ensure_installed = { "clangd", "pyright", "lua_ls", "bashls", "neocmake", "bufls", "yamlls" }, -- automatically install lsp
      },
    },
    {
      "folke/todo-comments.nvim",
      lazy = false,
      dependencies = { "nvim-lua/plenary.nvim" },
      opts = {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    },
    {
      "jay-babu/mason-nvim-dap.nvim",
      opts = {
        ensure_installed = { "debugpy", "cpptools", "powershell_es" }, -- automatically install dap
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
    },
    {
      "voloshinbogdan/jinja.vim",
      lazy = false
    },
    {
      "jose-elias-alvarez/null-ls.nvim",
      opts = {
        ensure_installed = { "flake8" }, -- automatically install linters
      }
    },
  }}

if not os.getenv("NVIMLIGHT") then
  -- add  codeium plugin to M.plugins
  table.insert(M.plugins,
    {
        "Exafunction/codeium.nvim",
        lazy = false,
        dependencies = {"nvim-lua/plenary.nvim", "hrsh7th/nvim-cmp"},
        config = function()
            local lspkind = require("lspkind")
            local cmp = require("cmp")
            local config = cmp.get_config()
            table.insert(config.sources, {
              name = 'codeium',
              ["priority"] = 1500,
              ["group_index"] = 1,
            })
            require("codeium").setup {
                cmp.setup(config),
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol",
                        maxwidth = 50,
                        ellipsis_char = '...',
                        symbol_map = {Codeium = ""}
                    })
                }
            }
        end
    })
else
  -- turn off codeium plugin in M.plugins

end


return M
