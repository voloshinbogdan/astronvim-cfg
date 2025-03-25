---@type LazySpec
return {
  {
    "chrisbra/csv.vim",
    config = function()
      vim.g.csv_default_delim = ";"
      vim.g.csv_delim = ";"
      vim.g.csv_delim_test = ";"
    end,
  },
}
