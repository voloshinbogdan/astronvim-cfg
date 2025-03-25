return {
  {
    "Wansmer/langmapper.nvim",
    dependencies = { "LazyVim/LazyVim" },
    priority = 1,
    lazy = false,

    config = function()
      vim.opt.langmap =
        "фисвуапршолдьтщзйкыегмцчняФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

      require("langmapper").setup {
        custom_desc = function(old_desc, method, lhs) return "which_key_ignore" end,
      }
    end,
  },
}
