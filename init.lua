-- GLOBAL OPTIONS
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = false
vim.g.docker_service_name = 'web'
vim.g.docker_debug = true

-- LOCAL OPTIOINS
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 4 -- Number of spaces for indent
vim.opt.tabstop = 4 -- Number of spaces for a tab
vim.opt.softtabstop = 4 -- Number of spaces for <Tab> in insert mode
vim.opt.breakindent = true
vim.opt.formatoptions:remove { 'r', 'o' } -- Don't auto comment new lines
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes' -- Always show the sign column
vim.opt.updatetime = 250 -- Time in ms to wait in ms before triggering CursorHold events
vim.opt.timeoutlen = 300 -- Time to wait in ms for a mapped sequence to complete
vim.opt.splitright = true -- New splits open to the right
vim.opt.splitbelow = true -- New splits open to the below
vim.opt.list = true -- Show whitespace characters
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- Show special characters for tabs, trailing spaces, and non-breaking spaces
vim.opt.inccommand = 'split' -- Show live substitutions in a split
vim.opt.cursorline = true -- Highlight the line under the cursor
vim.opt.scrolloff = 10 -- Keep 10 lines visible above/below cursor
vim.opt.confirm = true -- Confirm quitting without saving

vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)

-- 4-space indentation for some languages
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'javascript', 'json' },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- 2-space indentation for others
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'html', 'css', 'scss', 'sass', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'vue', 'json', 'jsonc', 'lua' },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Django template settings
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'htmldjango' },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.commentstring = '{# %s #}'
  end,
})

-- Python settings for Django
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'python' },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.textwidth = 88 -- Black default line length
  end,
})
-- Basic keymaps
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Quick file navigation for Django projects
vim.keymap.set('n', '<leader>fm', '<cmd>Telescope find_files search_dirs={"models"}<CR>', { desc = '[F]ind [M]odels' })
vim.keymap.set('n', '<leader>fv', '<cmd>Telescope find_files search_dirs={"views"}<CR>', { desc = '[F]ind [V]iews' })
vim.keymap.set('n', '<leader>fu', '<cmd>Telescope find_files search_dirs={"urls"}<CR>', { desc = '[F]ind [U]rls' })
vim.keymap.set('n', '<leader>ft', '<cmd>Telescope find_files search_dirs={"templates"}<CR>', { desc = '[F]ind [T]emplates' })
vim.keymap.set('n', '<leader>fs', '<cmd>Telescope find_files search_dirs={"static"}<CR>', { desc = '[F]ind [S]tatic files' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier to discover.
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Split navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<leader>tt', function() -- Open terminal in a split window on the bottom
  vim.cmd.new()
  vim.cmd.term()
  vim.api.nvim_win_set_height(0, 15)
end, { desc = '[T]erminal' })

-- Highlight when yanking text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Install LSP servers with Mason
vim.api.nvim_create_user_command('InstallLspServers', function()
  local servers = {
    -- Linters and formatters
    'stylua',
    'black',
    'isort',
    'flake8',
    'prettier',
    'eslint_d',
    'stylelint',

    -- Language servers
    'pyright',
    'ts_ls',
    'vuels',
    'cssls',
    'jsonls',
    'html',
    'lua_ls',
  }

  print 'Installing LSP servers via Mason...'
  for _, server in ipairs(servers) do
    if not vim.fn.executable(server) then
      print('Installing ' .. server .. '...')
      vim.cmd('MasonInstall ' .. server)
    else
      print(server .. ' is already installed.')
    end
  end
end, {})

-- Open terminal in a split window on the bottom with no line numbers
vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('cutom-term-open', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})

-- Install lazy.nvim plugin manager
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

-- TODO: Write a script to manage the theme
local theme = require 'themes.tokyonight'

-- Configure and install plugins
require('lazy').setup({
  theme,
  { import = 'plugins' }, -- Load plugins from a separate file
}, {
  git = {
    -- use ssh instead of https
    url_format = 'git@github.com:%s.git',
  },
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
