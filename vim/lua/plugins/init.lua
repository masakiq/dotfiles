return {
  {
    "masakiq/markdown-preview.nvim",
    branch = "nvim_generate_different_preview_url_for_each_session",
  },
  { "selimacerbas/live-server.nvim" },
  {
    "nvim-lua/plenary.nvim",
  },
  {
    "masakiq/telescope.nvim",
    branch = "strip_path_prefix",
    dependencies = {
      "plenary.nvim",
      "nvim-web-devicons",
    },
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    dependencies = { "telescope.nvim" },
  },
  {
    "dart-lang/dart-vim-plugin",
  },
  {
    "jparise/vim-graphql",
  },
  {
    "maxmellon/vim-jsx-pretty",
  },
  {
    "rcmdnk/vim-markdown",
  },
  {
    "folke/tokyonight.nvim",
    priority = 1000,
  },
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-web-devicons" },
  },
  {
    "nvim-tree/nvim-web-devicons",
  },
  {
    "MunifTanjim/nui.nvim",
  },
  {
    "masakiq/vim-tabline",
  },
  {
    "liuchengxu/vim-which-key",
  },
  {
    "easymotion/vim-easymotion",
  },
  {
    "haya14busa/incsearch-easymotion.vim",
    dependencies = { "incsearch.vim", "vim-easymotion" },
  },
  {
    "haya14busa/incsearch-fuzzy.vim",
    dependencies = { "incsearch.vim" },
  },
  {
    "haya14busa/incsearch.vim",
  },
  {
    "matze/vim-move",
  },
  {
    "mg979/vim-visual-multi",
    init = function()
      require("config.visual_multi").setup()
    end,
  },
  {
    "jiangmiao/auto-pairs",
  },
  {
    "wellle/targets.vim",
  },
  {
    "tpope/vim-commentary",
  },
  {
    "tpope/vim-surround",
  },
  {
    "mattn/vim-maketable",
  },
  {
    "mtdl9/vim-log-highlighting",
  },
  {
    "zbirenbaum/copilot.lua",
  },
  {
    "masakiq/claudecode.nvim",
    branch = "diff_strip_path_prefix",
  },
}
