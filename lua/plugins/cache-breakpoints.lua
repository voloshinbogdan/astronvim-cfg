return {
  {
    "Weissle/persistent-breakpoints.nvim",
    opts = { load_breakpoints_event = { "BufReadPost" } },
    lazy = false,
  },
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        n = {
          -- Build
          ["<Leader>dB"] = { "<cmd>PBClearAllBreakpoints<cr>", desc = "Toggle Breakpoint (F9)" },
          ["<Leader>db"] = { "<cmd>PBToggleBreakpoint<cr>", desc = "Toggle Breakpoint (F9)" },
          ["<F9>"] = { "<cmd>PBToggleBreakpoint<cr>", desc = "Toggle Breakpoint" },
          ["<Leader>dC"] = { "<cmd>PBSetConditionalBreakpoint<cr>", desc = "Conditional Breakpoint (S-F9)" },
          ["<F21>"] = { "<cmd>PBSetConditionalBreakpoint<cr>", desc = "<F9> Toggle Breakpoint" },
        },
      },
    },
  },
}
