local visual_multi = require("config.visual_multi")
local group = vim.api.nvim_create_augroup("dotfiles_visual_multi", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  callback = function()
    visual_multi.apply_highlights()
  end,
})

visual_multi.apply_highlights()
