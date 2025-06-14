vim.api.nvim_create_autocmd("FileType", {
  pattern = "dart",
  callback = function()
    vim.lsp.start({
      name = "dartls",
      root_dir = vim.fs.dirname(vim.fs.find({ "pubspec.yaml", ".git" }, { upward = true })[1]),
      cmd = { "dart", "language-server", "--protocol=lsp" },
      filetypes = { "dart" },
      settings = {
        dart = {
          completeFunctionCalls = true,
        },
      },
    })
  end,
})
