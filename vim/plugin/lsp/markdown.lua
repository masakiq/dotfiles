vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "md" },
  callback = function()
    vim.lsp.start({
      name = "markdown-oxide",
      cmd = { "markdown-oxide" },
      root_dir = vim.fs.dirname(vim.fs.find({ ".git", "README.md" }, { upward = true })[1]),
      settings = {
        -- Optional: customize settings
        -- These would correspond to Markdown Oxide's configuration options
      },
    })
  end,
})
