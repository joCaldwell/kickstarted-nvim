return { -- Python docstring generator
  'heavenshell/vim-pydocstring',
  build = 'make install',
  ft = 'python',
  config = function()
    vim.g.pydocstring_formatter = 'google'
    vim.g.pydocstring_doq_path = 'doq'
  end,
}
