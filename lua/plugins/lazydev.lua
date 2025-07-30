return { -- LSP Plugins - ONLY for Lua development in Neovim
  'folke/lazydev.nvim',
  ft = 'lua', -- Only loads for Lua files
  opts = {
    library = {
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
  },
}
