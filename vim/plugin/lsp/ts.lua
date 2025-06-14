vim.api.nvim_create_autocmd("FileType", {
  pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  callback = function()
    vim.lsp.start({
      name = "tsserver",
      cmd = { "npx", "typescript-language-server", "--stdio" },
      root_dir = vim.fs.dirname(
        vim.fs.find({ ".git", "package.json", "tsconfig.json" }, { upward = true })[1] or vim.api.nvim_buf_get_name(0)
      ),
      init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
      },
      settings = {
        languages = {
          typescript = {
            {
              formatCommand = "prettier --stdin-filepath ${INPUT}",
              formatStdin = true,
            },
          },
          javascript = {
            {
              formatCommand = "prettier --stdin-filepath ${INPUT}",
              formatStdin = true,
            },
          },
        },
      },
    })
  end,
})
