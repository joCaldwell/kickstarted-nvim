return {
  {
    'bluz71/vim-moonfly-colors',
    name = 'moonfly',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.moonflyTransparent = false
      vim.g.moonflyCursorColor = true
      vim.g.moonflyNormalFloat = true
      vim.g.moonflyUndercurl = true
      vim.cmd.colorscheme 'moonfly'
    end,
  },
}
