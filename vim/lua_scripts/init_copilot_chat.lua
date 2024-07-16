require("CopilotChat").setup {
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
    TranslateJa = {
      prompt = 'Translate the selected sentence to Japanese, without line number',
      description = 'Translate the selected code to Japanese',
      selection = require('CopilotChat.select').visual,
    },
    TranslateEn = {
      prompt = 'Translate the selected sentence to English, without line number',
      description = 'Translate the selected code to English',
      selection = require('CopilotChat.select').visual,
    },
  },

  -- Key mappings
  mappings = {
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
