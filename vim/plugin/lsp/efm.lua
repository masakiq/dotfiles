vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "lua", "yaml", "html", "markdown", "sql" },
  callback = function()
    vim.lsp.start({
      name = "efm",
      cmd = { "efm-langserver" },
      root_dir = vim.fs.dirname(
        vim.fs.find({ ".git", "package.json" }, { upward = true })[1] or vim.api.nvim_buf_get_name(0)
      ),
      init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
      },
      settings = {
        languages = {
          json = {
            {
              formatCommand = "prettier --stdin --stdin-filepath ${INPUT} --parser json",
              formatStdin = true,
            },
          },
          yaml = { { formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true } },
          html = { { formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true } },
          markdown = {
            { formatCommand = "prettier --stdin-filepath ${INPUT}", formatStdin = true },
          },
          sql = {
            {
              formatCommand = "npx sql-formatter",
              formatStdin = true,
            },
          },
          lua = {
            {
              formatCommand = "stylua --search-parent-directories --stdin-filepath ${INPUT} -",
              formatStdin = true,
            },
          },
        },
      },
    })
  end,
})
