local wezterm = require 'wezterm'

return {
  font = wezterm.font_with_fallback({
    { family = "Hack Nerd Font Propo",     weight = "Bold", stretch = "Normal", style = "Normal" },
    { family = 'Hiragino Kaku Gothic Pro', weight = "Bold", stretch = "Normal", style = "Normal" },
  }),

  font_size = 13,
  -- 文字幅を調整する (デフォルトは1.0)
  cell_width = 1.1,

  -- 行間を調整する (デフォルトは1.0)
  line_height = 1.2,

  -- color_scheme = 'Dracula',
  use_ime = true,
  window_decorations = "RESIZE",
  hide_tab_bar_if_only_one_tab = true,
  window_background_gradient = {
    colors = { "#000000" },
  },

  colors = {
    -- カーソルの背景色（カーソルの色そのもの）
    cursor_bg = "#777777",

    -- カーソルのボーダー色
    cursor_border = "#FF5733",

    -- カーソル内のテキスト色
    cursor_fg = "#FFFFFF",

    -- 通常のテキストの色を設定（フォアグラウンドカラー）
    foreground = "#FFFFFF", -- 白色に設定（カラーコードを好みに合わせて変更）
  },
  keys = {
    -- コピーモードを開始するショートカットの設定
    { key = "Space", mods = "CTRL|SHIFT", action = wezterm.action.ActivateCopyMode },
  },
  window_close_confirmation = 'NeverPrompt',
}
