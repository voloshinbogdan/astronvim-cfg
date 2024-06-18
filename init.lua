function Dump(tbl, indent)
    if not indent then indent = 0 end
    local toprint = string.rep(" ", indent) .. "{\n"
    indent = indent + 2 
    for k, v in pairs(tbl) do
        toprint = toprint .. string.rep(" ", indent)
        if (type(k) == "number") then
            toprint = toprint .. "[" .. k .. "] = "
        elseif (type(k) == "string") then
            toprint = toprint .. k ..  " = "   
        end
        if (type(v) == "number") then
            toprint = toprint .. v .. ",\n"
        elseif (type(v) == "string") then
            toprint = toprint .. "\"" .. v .. "\",\n"
        elseif (type(v) == "table") then
            toprint = toprint .. Dump(v, indent + 2) .. ",\n"
        else
            toprint = toprint .. "\"" .. tostring(v) .. "\",\n"
        end
    end
    indent = indent - 2
    toprint = toprint .. string.rep(" ", indent) .. "}"
    return toprint
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
    if vim.g.quickfix_buffer ~= nil then
      vim.api.nvim_set_option_value("modifiable", true, { buf = buffer })
      vim.g.baleia.once(vim.g.quickfix_buffer)
      vim.api.nvim_set_option_value("modified", false, { buf = buffer })
      vim.api.nvim_set_option_value("modifiable", false, { buf = buffer })
    end
  end
end

-- Set up the key binding to toggle Neo-tree
function toggle_neo_tree()
  vim.cmd("Neotree toggle")
  if require("dap").session() then
    require("dapui").open({ reset = true })
  end
end

local M = {
  mappings = {
    -- first key is the mode
    n = {
      ["<leader>e"] = { "<cmd>lua toggle_neo_tree()<cr>", desc = "Toggle Explorer" },

      -- Tasks
      ["<Leader>fT"] = { "<cmd>TodoTelescope<cr>", desc = "Find Todo" },
      ["<Leader>r"] = { desc = "󱌣 Build"},
      ["<Leader>rq"] = { "<cmd>lua ToggleQuickfix()<cr>", desc = "Toggle Quickfix" },
      ["<Leader>rr"] = { "<cmd>Task start cmake run<cr>", desc = "Run"},
      ["<Leader>ra"] = { "<cmd>Task start cmake build_all<cr>", desc = "Build All"},
      ["<Leader>rb"] = { "<cmd>Task start cmake build<cr>", desc = "Build"},
      ["<Leader>ri"] = { "<cmd>Task start cmake configure<cr>", desc = "Default init"},
      ["<Leader>rt"] = { "<cmd>Task set_module_param cmake target<cr>", desc = "Target"},
      ["<Leader>rd"] = { "<cmd>Task start cmake debug<cr>", desc = "Debug"},
      ["<Leader>rx"] = { "<cmd>Task cancel<cr>", desc = "Cancel"},
      ["<Leader>rc"] = { "<cmd>Task start cmake clean<cr>", desc = "Clean"},
      ["<Leader>rR"] = { desc = "Run Config"},
      ["<Leader>rRa"] = { "<cmd>Task set_task_param cmake run args<cr>", desc = "Run Args"},
      ["<Leader>rRe"] = { "<cmd>Task set_task_param cmake run env<cr>", desc = "Run Env"},
      ["<Leader>rD"] = { desc = "Debug Config"},
      ["<Leader>rDa"] = { "<cmd>Task set_task_param cmake debug args<cr>", desc = "Debug Args"},
      ["<Leader>rDe"] = { "<cmd>Task set_task_param cmake debug env<cr>", desc = "Debug Env"},
      ["<Leader>rB"] = { desc = "Build Config"},
      ["<Leader>rBa"] = { "<cmd>Task set_task_param cmake build args<cr>", desc = "Build Args"},
      ["<Leader>rBe"] = { "<cmd>Task set_task_param cmake build env<cr>", desc = "Build Env"},
      ["<Leader>rA"] = { desc = "Build All Config"},
      ["<Leader>rAa"] = { "<cmd>Task set_task_param cmake build_all args<cr>", desc = "Build All Args"},
      ["<Leader>rAe"] = { "<cmd>Task set_task_param cmake build_all env<cr>", desc = "Build All Env"}
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
            vim.g.quickfix_buffer = buffer

            -- Store the original vim.fn.setqflist function
            local original_setqflist = vim.fn.setqflist

            vim.g.baleia.once(buffer)
            -- Override the vim.fn.setqflist function
            vim.fn.setqflist = function(list, action, what)
              -- Get the lines before updating the quickfix list
              local original_lines = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)

              -- Call the original setqflist function
              local result = original_setqflist(list, action, what)

              -- Get the lines after updating the quickfix list
              local new_lines = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)

              -- Find the range of new lines added
              local start = #original_lines
              local end_ = #new_lines

              if new_lines[1] ~= original_lines[1] then
                start = 0
                end_ = #new_lines
              end

              if start < end_ then
                vim.api.nvim_set_option_value("modifiable", true, { buf = buffer })
                vim.g.baleia.buf_set_lines(buffer, start, end_, false, vim.api.nvim_buf_get_lines(buffer, start, end_, false))
                vim.api.nvim_set_option_value("modified", false, { buf = buffer })
                vim.api.nvim_set_option_value("modifiable", false, { buf = buffer })
              end

              -- Return the result of the original setqflist function
              return result
            end

          end,
        })
      end
    },
    {
      "nvim-neotest/nvim-nio"
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
      init = function()

        local dap = require('dap')

        dap.configurations.cpp[1]["setupCommands"] = {
                    {
                        text = '-enable-pretty-printing',
                        description =  'enable pretty printing',
                        ignoreFailures = false
                    },
                }
        dap.configurations.cpp[2]["setupCommands"] = {
                    {
                        text = '-enable-pretty-printing',
                        description =  'enable pretty printing',
                        ignoreFailures = false
                    },
                }

---@diagnostic disable-next-line: missing-fields
        dap.configurations.cppdbg = {
          type='cppdbg',
          setupCommands =  {
                    {
                        text = '-enable-pretty-printing',
                        description =  'enable pretty printing',
                        ignoreFailures = false
                    }}
              }
      end
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
          dap_open_command = function() return require('dapui').open() end,
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
