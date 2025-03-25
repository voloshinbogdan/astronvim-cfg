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
          -- Search and Replace
          ["<leader>ro"] = {
            "<cmd>SearchReplaceSingleBufferOpen<cr>",
            desc = "Open search and replacn in current buffer",
          },
          ["<leader>rw"] = {
            "<cmd>SearchReplaceSingleBufferCFile<cr>",
            desc = "Replace word under cursor in current buffer",
          },
          ["<leader>rbb"] = {
            "<cmd>SearchReplaceMultiBufferOpen<cr>",
            desc = "Open search and replace across multiple buffers",
          },
          ["<leader>rbw"] = {
            "<cmd>SearchReplaceMultiBufferCWord<cr>",
            desc = "Replace word under cursor across multiple buffers",
          },
          ["<leader>rbW"] = {
            "<cmd>SearchReplaceMultiBufferCWORD<cr>",
            desc = "Replace WORD under cursor across multiple buffers",
          },
          ["<leader>rbe"] = {
            "<cmd>SearchReplaceMultiBufferCExpr<cr>",
            desc = "Replace expression under cursor across multiple buffers",
          },
          ["<leader>rbf"] = {
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
