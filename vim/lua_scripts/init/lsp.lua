require("config-local").setup({
  config_files = { ".lvimrc", ".nvim.lua" },
  silent = false,
})

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

local cwd = vim.loop.cwd()
if not vim.loop.fs_stat(cwd .. "/.nvim.lua") then
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

vim.opt.completeopt = { "menu", "menuone", "noselect" }

vim.keymap.set("n", "<space>f", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format document" })
local telescope = require("telescope.builtin")
vim.keymap.set("n", "gd", telescope.lsp_definitions, { buffer = bufnr, desc = "Go to definition with Telescope" })
vim.keymap.set("n", "gr", telescope.lsp_references, { buffer = bufnr, desc = "Find references with Telescope" })
vim.keymap.set(
  "n",
  "gi",
  telescope.lsp_implementations,
  { buffer = bufnr, desc = "Go to implementation with Telescope" }
)
vim.keymap.set("n", "<space>ds", telescope.lsp_document_symbols, { buffer = bufnr, desc = "Document symbols" })
vim.keymap.set("n", "<space>ws", telescope.lsp_workspace_symbols, { buffer = bufnr, desc = "Workspace symbols" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Show documentation" })
