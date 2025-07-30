return { -- Emmet for Vim wraps selected text in HTML tags, expands abbreviations, etc.
  'mattn/emmet-vim',
  ft = { 'html', 'css', 'scss', 'sass', 'vue', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
  config = function()
    vim.g.user_emmet_leader_key = '<C-e>'
    vim.g.user_emmet_settings = {
      javascript = {
        extends = 'jsx',
      },
      typescript = {
        extends = 'tsx',
      },
    }
  end,
}
