local custom_system_prompt_for_translate = [[
You are a proficient bilingual translator specializing in English and Japanese.
When given input in English, you will translate it accurately into Japanese.
When given input in Japanese, you will translate it accurately into English.
Ensure that your translations are clear, contextually appropriate, and maintain the original meaning.
Pay close attention to cultural nuances, idiomatic expressions, and the overall tone of the text.
Your goal is to provide seamless and natural translations that are easily understood by native speakers of both languages.
]]

local custom_additional_prompt = "And, please translate it into Japanese as well."

require("CopilotChat").setup({
  debug = true, -- Enable debugging
  model = "gpt-5-codex",
  highlight_selection = false,

  prompts = {
    Explain = {
      prompt = "/COPILOT_EXPLAIN Write an explanation for the active selection as paragraphs of text."
          .. custom_additional_prompt,
    },
    Review = {
      prompt = "/COPILOT_REVIEW Review the selected code."
          .. custom_additional_prompt
          .. "But do not translate `line={number}`.",
    },
    Translate = {
      system_prompt = custom_system_prompt_for_translate,
      prompt =
      "Translate the selected text accurately. Output only the translated results. Line numbers are also not required.",
      description = "Translate the selected sentence",
      selection = require("CopilotChat.select").visual,
    },
    Commit = {
      prompt =
          "> #git:staged\n\nWrite a commit message for the change following the commitizen convention. Keep the title within a maximum of 80 characters. No body is required. Wrap the entire message in a code block with the language set to gitcommit."
          .. custom_additional_prompt,
    },
  },

  -- Key mappings
  mappings = {
    complete = {
      -- detail = 'Use @<Tab> or /<Tab> for options.',
      insert = "", -- Disable insert mode mapping to use the original Copilot completion
    },
    close = {
      -- normal = 'q',
      insert = "", -- Disable insert mode mapping
    },
    submit_prompt = {
      normal = "<C-s>",
      -- insert = '<C-s>',
    },
  },
})

-- Define a command 'CopilotChatReviewClear' that clears diagnostics for the 'copilot_review' namespace
local function copilot_chat_review_clear()
  local ns = vim.api.nvim_create_namespace("copilot_diagnostics")
  vim.diagnostic.reset(ns)
end
vim.api.nvim_create_user_command("CopilotChatReviewClear", copilot_chat_review_clear, {})

-- Map <space>og to toggle Copilot Chat in normal mode, without remapping and not silently
vim.api.nvim_set_keymap("n", "<space>og", "<cmd>CopilotChatToggle<CR>", { noremap = true, silent = false })

-- Configure diagnostic display settings: disable virtual text, enable signs, disable updates in insert mode, enable underline. Set up an autocmd for CursorHold to open diagnostic float without focus. Set 'updatetime' to 500ms.
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  update_in_insert = false,
  underline = false,
})
vim.cmd([[
  autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus=false})
]])
vim.o.updatetime = 500

-- https://github.com/CopilotC-Nvim/CopilotChat.nvim/issues/379
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  -- pattern = 'copilot-*',
  pattern = "copilot-chat",
  callback = function(info)
    vim.api.nvim_create_autocmd("InsertEnter", {
      group = augroup,
      buffer = info.buf,
      desc = "Move to last line",
      -- nested = true,
      callback = function()
        vim.cmd("normal! 0")

        if vim.fn.search([[\m^##\s\+\S]], "cnW") > 0 then
          vim.cmd("normal! G$")
          vim.v.char = "x"
        end
      end,
    })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    -- add sleep 1 sec
    vim.defer_fn(function()
      -- Check if there are staged changes
      local diff = vim.fn.systemlist("git diff --cached")
      if #diff > 0 then
        vim.fn.setreg('"', table.concat(diff, "\n"))
        vim.cmd("CopilotChatCommit")
      end
    end, 100)
  end,
})
