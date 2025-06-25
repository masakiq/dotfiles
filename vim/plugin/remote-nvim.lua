-- remote-nvim.nvim configuration
require("remote-nvim").setup({
  -- These are default values for the plugin
  client_callback = function(port, _)
    require("remote-nvim.ui").float_term(
      ("ssh -L%s:localhost:%s hostname_or_ip"):format(port, port),
      function(exit_code)
        if exit_code ~= 0 then
          vim.notify("Failed to connect to remote server", vim.log.levels.ERROR)
        end
      end
    )
  end,

  -- Offline mode config
  offline_mode = {
    -- Should offline mode be enabled?
    enabled = false,
    -- For offline mode, specify neovim release version
    version = "stable",
  },

  -- Remote config
  remote = {
    app_name = "nvim", -- This has to align with your client. For Neovim, this should be "nvim".
    -- List of directories that should be copied over
    copy_dirs = {
      -- You can disable any of these as per your needs
      config = {
        base = vim.fn.stdpath("config"), -- Path of the local directory
        dirs = "*",                      -- Directories that should be copied over. "*" means all directories. You can also specify a list: {"plugin", "ftplugin"} or you can specify a pattern: "*"
        -- If compression should be enabled
        compression = {
          enabled = false,
        },
      },
      data = {
        base = vim.fn.stdpath("data"),
        dirs = {
          "lazy", -- You can specify individual directories under data directory
        },
        -- If compression should be enabled
        compression = {
          enabled = true,
        },
      },
      cache = {
        base = vim.fn.stdpath("cache"),
        dirs = "*",
        compression = {
          enabled = true,
        },
      },
      state = {
        base = vim.fn.stdpath("state"),
        dirs = "*",
        compression = {
          enabled = true,
        },
      },
    },
  },

  -- You can supply your own callback that should be called to create connection.
  -- This completely overrides the default behavior. If this is present, default
  -- connection behavior will be ignored.
  -- Example of a custom client callback
  -- client_callback = function(port, workspace_config)
  --   local cmd = ("ssh -L%s:localhost:%s %s"):format(port, port, workspace_config.host)
  --   if workspace_config.ssh_config_file_path ~= nil then
  --     cmd = cmd .. (" -F %s"):format(workspace_config.ssh_config_file_path)
  --   end
  --   require("remote-nvim.ui").float_term(cmd, function(exit_code)
  --     if exit_code ~= 0 then
  --       vim.notify("Failed to connect to remote server", vim.log.levels.ERROR)
  --     end
  --   end)
  -- end,

  -- Upload log files to when transfer or configuration fails
  log = {
    -- Where should logs be uploaded?
    upload = {
      enabled = false, -- Enable/disable log upload. When disabled, you just upload logs manually.
      -- stylua: ignore
      dst = "tmpfile", -- Supported options are "tmpfile" (https://tmpfiles.org) or "pastepatch" (https://pastepatch.com)
    },
  },

  -- Devcontainer configuration
  devpod = {
    binary = "devpod",
    docker_binary = "docker", 
    ssh_config_path = vim.fn.stdpath("data") .. "/remote-nvim/ssh_config",
    search_style = "current_dir_only", -- "current_dir_only" or "workspace"
    dotfiles = {
      path = nil,
      install_script = nil
    },
    gpg_agent_forwarding = false,
    container_list = "running_only" -- "running_only" or "all"
  },
})

-- Key mappings for remote-nvim
-- Check if the plugin is loaded before setting keymaps
local ok, remote_nvim = pcall(require, "remote-nvim")
if ok then
  -- Debug: print available methods
  -- print("remote-nvim module loaded, methods:", vim.inspect(remote_nvim))

  -- Use commands instead of direct API calls since the exact API is unclear
  vim.keymap.set("n", "<leader>ec", "<cmd>RemoteStart<CR>", { desc = "Start remote session" })
  vim.keymap.set("n", "<leader>ed", "<cmd>RemoteStop<CR>", { desc = "Stop remote session" })
  vim.keymap.set("n", "<leader>ei", "<cmd>RemoteInfo<CR>", { desc = "Show remote info" })
  vim.keymap.set("n", "<leader>es", "<cmd>RemoteConfigDel<CR>", { desc = "Delete remote config" })
  vim.keymap.set("n", "<leader>el", "<cmd>RemoteLog<CR>", { desc = "Show remote log" })
else
  print("Failed to load remote-nvim plugin")
end
