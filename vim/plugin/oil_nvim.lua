require("oil").setup({
  delete_to_trash = true,
  cleanup_delay_ms = 100,
  float = {
    padding = 3,
    get_win_title = function()
      return get_oil_winbar()
    end,
  },
  view_options = {
    show_hidden = true,
  },
  keymaps = {
    ["<C-s>"] = {
      callback = function()
        local oil = require("oil")
        local entry = oil.get_cursor_entry()
        if entry then
          local dir = oil.get_current_dir()
          local path = dir .. entry.name
          local stat = vim.loop.fs_stat(path)
          if stat and stat.type == "file" then
            local relative_path = vim.fn.fnamemodify(path, ":.")
            oil.close()
            vim.cmd("split " .. vim.fn.fnameescape(relative_path))
          else
            oil.select()
          end
        end
      end,
    },
    ["<C-v>"] = {
      callback = function()
        local oil = require("oil")
        local entry = oil.get_cursor_entry()
        if entry then
          local dir = oil.get_current_dir()
          local path = dir .. entry.name
          local stat = vim.loop.fs_stat(path)
          if stat and stat.type == "file" then
            local relative_path = vim.fn.fnamemodify(path, ":.")
            oil.close()
            vim.cmd("vsplit " .. vim.fn.fnameescape(relative_path))
          else
            oil.select()
          end
        end
      end,
    },
    ["<C-e>"] = {
      callback = function()
        local oil = require("oil")
        local entry = oil.get_cursor_entry()
        if entry then
          local dir = oil.get_current_dir()
          local path = dir .. entry.name
          local stat = vim.loop.fs_stat(path)
          if stat and stat.type == "file" then
            local relative_path = vim.fn.fnamemodify(path, ":.")
            oil.close()
            vim.cmd("edit " .. vim.fn.fnameescape(relative_path))
          else
            oil.select()
          end
        end
      end,
    },
    ["<C-t>"] = {
      callback = function()
        local oil = require("oil")
        local entry = oil.get_cursor_entry()
        if entry then
          local dir = oil.get_current_dir()
          local path = dir .. entry.name
          local stat = vim.loop.fs_stat(path)
          if stat and stat.type == "file" then
            local relative_path = vim.fn.fnamemodify(path, ":.")
            oil.close()
            vim.cmd("tabnew " .. vim.fn.fnameescape(relative_path))
          else
            oil.select()
          end
        end
      end,
    },
    ["<Enter>"] = {
      callback = function()
        local oil = require("oil")
        local entry = oil.get_cursor_entry()
        if entry then
          local dir = oil.get_current_dir()
          local path = dir .. entry.name
          local stat = vim.loop.fs_stat(path)
          if stat and stat.type == "file" then
            local relative_path = vim.fn.fnamemodify(path, ":.")
            oil.close()
            vim.cmd("tab drop " .. vim.fn.fnameescape(relative_path))
          else
            oil.select()
          end
        end
      end,
    },
  },
})

vim.api.nvim_create_augroup("OilRelPathFix", {})
vim.api.nvim_create_autocmd("BufLeave", {
  group = "OilRelPathFix",
  pattern = "oil:///*",
  callback = vim.schedule_wrap(function()
    vim.cmd("cd .")
  end),
})

vim.api.nvim_create_autocmd("User", {
  pattern = "OilEnter",
  callback = vim.schedule_wrap(function(args)
    local oil = require("oil")
    oil.set_columns({ "size", "mtime", "icon" })
    if vim.api.nvim_get_current_buf() == args.data.buf and oil.get_cursor_entry() then
      oil.open_preview()
      vim.cmd("set nonumber")
    end
  end),
})

-- Declare a global function to retrieve the current directory
function _G.get_oil_winbar()
  local dir = require("oil").get_current_dir()
  if dir then
    local current_dir = vim.fn.getcwd()
    return vim.fn.fnamemodify(dir, ":." .. current_dir)
  else
    return vim.api.nvim_buf_get_name(0)
  end
end

vim.keymap.set("n", "<space>oe", function()
  require("oil").toggle_float()
end, { desc = "Oil current buffer's directory" })
