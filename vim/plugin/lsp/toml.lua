vim.api.nvim_create_autocmd("FileType", {
  pattern = { "toml" },
  callback = function()
    vim.lsp.start({
      name = "taplo",
      cmd = { "taplo", "lsp", "stdio" },
      root_dir = vim.fs.dirname(vim.fs.find({ ".git", "*.toml" }, { upward = true })[1]),
      settings = {},
    })
  end,
})
