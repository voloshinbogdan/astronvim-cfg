return {
  {
    "roobert/search-replace.nvim",
    opts = {
      default_replace_single_buffer_options = "gI",
      default_replace_multi_buffer_options = "egI",
    },
  },
  {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
      mappings = {
        n = {
          ["<leader>?"] = { desc = "Replace" },
          -- Search and Replace
          ["<leader>?o"] = {
            "<cmd>SearchReplaceSingleBufferOpen<cr>",
            desc = "Open search and replacn in current buffer",
          },
          ["<leader>?w"] = {
            "<cmd>SearchReplaceSingleBufferCFile<cr>",
            desc = "Replace word under cursor in current buffer",
          },

          ["<leader>?m"] = { desc = "Replace in multiple buffers" },

          ["<leader>?mb"] = {
            "<cmd>SearchReplaceMultiBufferOpen<cr>",
            desc = "Open search and replace across multiple buffers",
          },
          ["<leader>?mw"] = {
            "<cmd>SearchReplaceMultiBufferCWord<cr>",
            desc = "Replace word under cursor across multiple buffers",
          },
          ["<leader>?mW"] = {
            "<cmd>SearchReplaceMultiBufferCWORD<cr>",
            desc = "Replace WORD under cursor across multiple buffers",
          },
          ["<leader>?me"] = {
            "<cmd>SearchReplaceMultiBufferCExpr<cr>",
            desc = "Replace expression under cursor across multiple buffers",
          },
          ["<leader>?mf"] = {
            "<cmd>SearchRepbaceMultiBufferCFile<cr>",
            desc = "Replace file name under cursor across multiple buffers",
          },
        },
        v = {
          -- Visual Mode Search and Replace
          ["<C-s>"] = { "<cmd>SearchReplaceSingleBufferVisualSelection<cr>", desc = "Replace visual selection" },
          ["<C-r>"] = {
            "<cmd>SearchReplaceWithinVisualSelection<cr>",
            desc = "Replace within visual selection",
          },
          ["<C-b>"] = {
            "<cmd>SearchReplaceWithinVisualSelectionCWord<cr>",
            desc = "Replace within visual selection CWord",
          },
        },
      },
    },
  },
}
