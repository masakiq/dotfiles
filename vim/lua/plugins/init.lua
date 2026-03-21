local fn = vim.fn

local function local_plugin_path(path)
  local expanded = fn.expand(path)
  if fn.isdirectory(expanded) == 1 then
    return expanded
  end
  return nil
end

local function plugin(repo, opts)
  opts = opts or {}

  local local_dir = opts.local_dir and local_plugin_path(opts.local_dir) or nil
  opts.local_dir = nil

  if local_dir then
    opts.dir = local_dir
  else
    opts[1] = repo
  end

  return opts
end

return {
  plugin("selimacerbas/markdown-preview.nvim", {
    local_dir = "~/.vim/plugged/markdown-preview.nvim",
  }),
  plugin("selimacerbas/live-server.nvim", {
    local_dir = "~/.vim/plugged/live-server.nvim",
  }),
  plugin("nvim-lua/plenary.nvim", {
    local_dir = "~/.vim/plugged/plenary.nvim",
    commit = "a3e3bc82a3f95c5ed0d7201546d5d2c19b20d683",
  }),
  plugin("masakiq/telescope.nvim", {
    local_dir = "~/.vim/plugged/telescope.nvim",
    branch = "strip_path_prefix",
    dependencies = {
      "plenary.nvim",
      "nvim-web-devicons",
    },
  }),
  plugin("dart-lang/dart-vim-plugin", {
    local_dir = "~/.vim/plugged/dart-vim-plugin",
    commit = "928302ec931caf0dcf21835cca284ccd2b192f7b",
  }),
  plugin("jparise/vim-graphql", {
    local_dir = "~/.vim/plugged/vim-graphql",
    commit = "996749a7d69a3709768fa8c4d259f79b5fd9bdb1",
  }),
  plugin("maxmellon/vim-jsx-pretty", {
    local_dir = "~/.vim/plugged/vim-jsx-pretty",
    commit = "6989f1663cc03d7da72b5ef1c03f87e6ddb70b41",
  }),
  plugin("rcmdnk/vim-markdown", {
    local_dir = "~/.vim/plugged/vim-markdown",
    commit = "9a5572a18b2d0bbe96b2ed625f5fbe0462dbd801",
  }),
  plugin("folke/tokyonight.nvim", {
    local_dir = "~/.vim/plugged/tokyonight",
    commit = "2c85fad417170d4572ead7bf9fdd706057bd73d7",
    priority = 1000,
  }),
  plugin("stevearc/oil.nvim", {
    local_dir = "~/.vim/plugged/oil.nvim",
    commit = "cca1631d5ea450c09ba72f3951a9e28105a3632c",
    dependencies = { "nvim-web-devicons" },
  }),
  plugin("nvim-tree/nvim-web-devicons", {
    local_dir = "~/.vim/plugged/nvim-web-devicons",
    commit = "56f17def81478e406e3a8ec4aa727558e79786f3",
  }),
  plugin("MunifTanjim/nui.nvim", {
    local_dir = "~/.vim/plugged/nui.nvim",
    commit = "61574ce6e60c815b0a0c4b5655b8486ba58089a1",
  }),
  plugin("masakiq/vim-tabline", {
    local_dir = "~/.vim/plugged/vim-tabline",
    commit = "ddebfdd25e6de91e3e89c2ec18c80cd3d2adadd9",
  }),
  plugin("liuchengxu/vim-which-key", {
    local_dir = "~/.vim/plugged/vim-which-key",
    commit = "470cd19ce11b616e0640f2b38fb845c42b31a106",
  }),
  plugin("easymotion/vim-easymotion", {
    local_dir = "~/.vim/plugged/vim-easymotion",
    commit = "b3cfab2a6302b3b39f53d9fd2cd997e1127d7878",
  }),
  plugin("haya14busa/incsearch-easymotion.vim", {
    local_dir = "~/.vim/plugged/incsearch-easymotion.vim",
    commit = "fcdd3aee6f4c0eef1a515727199ece8d6c6041b5",
    dependencies = { "incsearch.vim", "vim-easymotion" },
  }),
  plugin("haya14busa/incsearch-fuzzy.vim", {
    local_dir = "~/.vim/plugged/incsearch-fuzzy.vim",
    commit = "b08fa8fbfd633e2f756fde42bfb5251d655f5403",
    dependencies = { "incsearch.vim" },
  }),
  plugin("haya14busa/incsearch.vim", {
    local_dir = "~/.vim/plugged/incsearch.vim",
    commit = "c83de6d1ac31d173d7c3ffee0ad61dc643ee4f08",
  }),
  plugin("matze/vim-move", {
    local_dir = "~/.vim/plugged/vim-move",
    commit = "244a2908ffbca3d09529b3ec24c2c090f489f401",
  }),
  plugin("mg979/vim-visual-multi", {
    local_dir = "~/.vim/plugged/vim-visual-multi",
    commit = "724bd53adfbaf32e129b001658b45d4c5c29ca1a",
  }),
  plugin("jiangmiao/auto-pairs", {
    local_dir = "~/.vim/plugged/auto-pairs",
    commit = "39f06b873a8449af8ff6a3eee716d3da14d63a76",
  }),
  plugin("wellle/targets.vim", {
    local_dir = "~/.vim/plugged/targets.vim",
    commit = "6325416da8f89992b005db3e4517aaef0242602e",
  }),
  plugin("tpope/vim-commentary", {
    local_dir = "~/.vim/plugged/vim-commentary",
    commit = "c4b8f52cbb7142ec239494e5a2c4a512f92c4d07",
  }),
  plugin("tpope/vim-surround", {
    local_dir = "~/.vim/plugged/vim-surround",
    commit = "3d188ed2113431cf8dac77be61b842acb64433d9",
  }),
  plugin("mattn/vim-maketable", {
    local_dir = "~/.vim/plugged/vim-maketable",
    commit = "d72e73f333c64110524197ec637897bd1464830f",
  }),
  plugin("mtdl9/vim-log-highlighting", {
    local_dir = "~/.vim/plugged/vim-log-highlighting",
    commit = "1037e26f3120e6a6a2c0c33b14a84336dee2a78f",
  }),
  plugin("zbirenbaum/copilot.lua", {
    local_dir = "~/.vim/plugged/copilot.lua",
    commit = "8e2a91828210d6043744468f6d7027d256a41f42",
  }),
  plugin("masakiq/claudecode.nvim", {
    local_dir = "~/.vim/plugged/claudecode.nvim",
    branch = "diff_strip_path_prefix",
  }),
}
