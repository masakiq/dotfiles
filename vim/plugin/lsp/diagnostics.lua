local diagnostic_group = vim.api.nvim_create_augroup("dotfiles_lsp_diagnostics", {
  clear = true,
})

local function diagnostic_key(diagnostic)
  return table.concat({
    diagnostic.lnum or -1,
    diagnostic.col or -1,
    diagnostic.end_lnum or -1,
    diagnostic.end_col or -1,
    diagnostic.severity or -1,
    diagnostic.code or "",
    diagnostic.message or "",
  }, "\31")
end

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  update_in_insert = false,
  underline = false,
  severity_sort = true,
})

vim.o.updatetime = 500

vim.api.nvim_create_autocmd("CursorHold", {
  group = diagnostic_group,
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" then
      return
    end

    local line = vim.api.nvim_win_get_cursor(0)[1] - 1
    local diagnostics = vim.diagnostic.get(args.buf, { lnum = line })
    if vim.tbl_isempty(diagnostics) then
      return
    end

    local seen = {}
    vim.diagnostic.open_float(args.buf, {
      focus = false,
      scope = "line",
      source = "if_many",
      format = function(diagnostic)
        local key = diagnostic_key(diagnostic)
        if seen[key] then
          return nil
        end

        seen[key] = true
        return diagnostic.message
      end,
    })
  end,
})
