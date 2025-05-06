local cwd = vim.loop.cwd()
if vim.loop.fs_stat(cwd .. "/.nvim.lua") then
  dofile(cwd .. "/.nvim.lua")
else
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "ruby",
    callback = function()
      vim.lsp.start({
        name = "rubocop",
        cmd = { "rubocop", "--lsp" },
        root_dir = vim.fs.dirname(vim.fs.find({
          ".git",
          ".rubocop.yml",
          "Gemfile",
        }, { upward = true })[1] or vim.api.nvim_buf_get_name(0)),
        settings = {
          rubocop = {
            useBundler = false,
            lint = true,
            autocorrect = true,
            safeAutocorrect = false,
          },
        },
      })
    end,
  })
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "ruby",
    callback = function()
      local bufnr = vim.api.nvim_get_current_buf()

      vim.lsp.start({
        name = "ruby-lsp",
        cmd = { "ruby-lsp" },
        root_dir = vim.fs.dirname(vim.fs.find({
          ".git",
          "Gemfile",
        }, { upward = true })[1] or vim.api.nvim_buf_get_name(0)),
        capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {
          textDocument = {
            completion = {
              completionItem = {
                snippetSupport = true,
                preselectSupport = true,
                insertReplaceSupport = true,
                documentationFormat = { "markdown", "plaintext" },
              },
            },
          },
        }),
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        buffer = bufnr,
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          if client and client.supports_method("textDocument/completion") then
            vim.api.nvim_create_autocmd("InsertCharPre", {
              buffer = bufnr,
              callback = function()
                local char = vim.v.char
                if char == "." or char == ":" then
                  vim.schedule(function()
                    vim.lsp.omnifunc(1, 1)
                  end)
                end
              end,
            })
          end
        end,
      })
    end,
  })
end
