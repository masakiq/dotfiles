require("avante_lib").load()
require("avante").setup({
  provider = "copilot",
  dependencies = {
    "HakonHarnes/img-clip.nvim",
    { "MeanderingProgrammer/render-markdown.nvim", ft = { "markdown", "Avante" } },
  },
  opts = {
    image_paste = { embed_image_as_base64 = false },
    markdown = { file_types = { "markdown", "Avante" } },
  },
  windows = {
    position = "right",
    width = 50,
  },
})

vim.keymap.set("n", "<space>oa", function()
  require("avante.api").toggle()
end, { desc = "avante: toggle panel" })
