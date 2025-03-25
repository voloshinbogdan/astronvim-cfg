if not os.getenv "NVIMLIGHT" then
  -- add  codeium plugin to M.plugins
  table.insert(M.plugins, {
    "Exafunction/codeium.nvim",
    lazy = false,
    dependencies = { "nvim-lua/plenary.nvim", "hrsh7th/nvim-cmp" },
    config = function()
      local lspkind = require "lspkind"
      local cmp = require "cmp"
      local config = cmp.get_config()
      table.insert(config.sources, {
        name = "codeium",
        ["priority"] = 1500,
        ["group_index"] = 1,
      })
      require("codeium").setup {
        cmp.setup(config),
        formatting = {
          format = lspkind.cmp_format {
            mode = "symbol",
            maxwidth = 50,
            ellipsis_char = "...",
            symbol_map = { Codeium = "" },
          },
        },
      }
    end,
  })
else
  -- turn off codeium plugin in M.plugins
end

return M
