return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      view_options = {
        show_hidden = true, -- Show hidden files and directories
        show_icon = true, -- Show icons in the file explorer
      },
    },
    keys = {
      { '-', '<cmd>Oil<CR>', desc = 'Open parent directory in Oil' },
    },
    -- Optional dependencies
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    lazy = false, -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  },
}
