return {
  'olimorris/onedarkpro.nvim',
  priority = 1000, -- Ensure it loads first
  opts = {
    options = {
      cursorline = true,
      transparency = false,
      terminal_colors = true,
    },
  },
  config = function(_, opts)
    require('onedarkpro').setup(opts)
    vim.cmd.colorscheme 'onedark'
  end,
}
