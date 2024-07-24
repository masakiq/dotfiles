local custom_system_prompt_for_translate = [[
You are a proficient bilingual translator specializing in English and Japanese.
When given input in English, you will translate it accurately into Japanese.
When given input in Japanese, you will translate it accurately into English.
Ensure that your translations are clear, contextually appropriate, and maintain the original meaning.
Pay close attention to cultural nuances, idiomatic expressions, and the overall tone of the text.
Your goal is to provide seamless and natural translations that are easily understood by native speakers of both languages.
]]

require('CopilotChat').setup {
  debug = true, -- Enable debugging
  model = 'gpt-4-0125-preview',

  -- The default prompt to use when no prompt is specified
  -- prompts = {
  --   Explain = {
  --     prompt = '/COPILOT_EXPLAIN 選択箇所のコードについて、段落形式で説明文を作成してください。',
  --   },
  --   Review = {
  --     prompt = '/COPILOT_REVIEW 選択箇所のコードについて、レビューしてください。',
  --   },
  --   Tests = {
  --     prompt = '/COPILOT_TESTS 選択箇所のコードについて、単体テストを生成してください。',
  --   },
  --   Fix = {
  --     prompt = '/COPILOT_FIX 選択箇所のコードに問題があります。コードを修正して、バグが修正された状態で表示してください。',
  --   },
  --   Optimize = {
  --     prompt = '/COPILOT_REFACTOR 選択したコードを改善して、効率性と読みやすさを向上させてください。',
  --   },
  --   Docs = {
  --     prompt = '/COPILOT_REFACTOR 選択したコードのドキュメントを作成してください。プログラミング言語に最適なドキュメントスタイルを採用してください。',
  --   },
  -- },

  prompts = {
    Translate = {
      system_prompt = custom_system_prompt_for_translate,
      prompt =
      'Translate the selected text accurately. Output only the translated results. Line numbers are also not required.',
      description = 'Translate the selected sentence',
      selection = require('CopilotChat.select').visual,
    },
    GitBranch = {
      prompt =
      'Please come up with 5 git branch names by the selected difference.',
      selection = require('CopilotChat.select').gitdiff,
    }
  },

  -- Key mappings
  mappings = {
    complete = {
      -- detail = 'Use @<Tab> or /<Tab> for options.',
      insert = '', -- Disable insert mode mapping to use the original Copilot completion
    },
    close = {
      -- normal = 'q',
      insert = '', -- Disable insert mode mapping
    },
    submit_prompt = {
      normal = '<C-s>',
      -- insert = '<C-s>',
    },
  }
}

local function copilot_chat_review_clear()
  local ns = vim.api.nvim_create_namespace('copilot_review')
  vim.diagnostic.reset(ns)
end

vim.api.nvim_create_user_command(
  'CopilotChatReviewClear',
  copilot_chat_review_clear,
  {}
)
