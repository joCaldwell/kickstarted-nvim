return {
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    opts = {
      style = 'night',
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = false },
        keywords = { italic = false },
        functions = { italic = false },
        variables = { italic = false },
      },
      dim_inactive = true,
      lualine_bold = true,
    },
    config = function(_, opts)
      require('tokyonight').setup(opts)
      vim.cmd.colorscheme 'tokyonight-night'

      -- Override background color for active windows
      vim.api.nvim_set_hl(0, 'Normal', { bg = '#15161c' }) -- darker than default #1f2335
      vim.api.nvim_set_hl(0, 'NormalNC', { bg = '#0f0f16' }) -- dimmed inactive background
    end,
  },
}
