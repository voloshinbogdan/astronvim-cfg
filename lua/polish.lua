-- This will run last in the setup process and is a good place to configure
-- things like custom filetypes. This is just pure lua so anything that doesn't
-- fit in the normal config locations above can go here

-- Set up custom filetypes
-- vim.filetype.add {
--   extension = {
--     foo = "fooscript",
--   },
--   filename = {
--     ["Foofile"] = "fooscript",
--   },
--   pattern = {
--     ["~/%.config/foo/.*"] = "fooscript",
--   },
-- }

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.template",
  command = "call jinja#AdjustCompoundFiletype(expand('<afile>'))",
})

local dap = require "dap"

for i, config in ipairs(dap.configurations.cpp) do
  dap.configurations.cpp[i] = vim.tbl_deep_extend("force", config, {
    setupCommands = {
      {
        text = "-enable-pretty-printing",
        description = "Enable pretty printing",
        ignoreFailures = false,
      },
    },
  })
end

for i, config in ipairs(dap.configurations.asm) do
  dap.configurations.asm[i] = vim.tbl_deep_extend("force", config, {
    setupCommands = {
      {
        text = "-enable-pretty-printing",
        description = "Enable pretty printing",
        ignoreFailures = false,
      },
    },
  })
end

for i, config in ipairs(dap.configurations.c) do
  dap.configurations.c[i] = vim.tbl_deep_extend("force", config, {
    setupCommands = {
      {
        text = "-enable-pretty-printing",
        description = "Enable pretty printing",
        ignoreFailures = false,
      },
    },
  })
end

require("langmapper").automapping { global = true, buffer = true }
