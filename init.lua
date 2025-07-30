-- GLOBAL OPTIONS
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = false

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

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>.
-- NOTE: This won't work in all terminal emulators/tmux/etc.
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Split navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

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

vim.keymap.set('n', '<leader>tt', function()
  -- Open terminal in a split window on the bottom
  vim.cmd.new()
  vim.cmd.term()
  vim.api.nvim_win_set_height(0, 15) -- Set terminal height to 15 lines
end, { desc = '[T]erminal' })

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
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
      { 'j-hui/fidget.nvim', opts = {} }, -- notification on startup
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
          map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')
          map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')
          map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local lspconfig = require 'lspconfig'

      -- Python/Django support
      lspconfig.pyright.setup {
        capabilities = capabilities,
        settings = {
          python = {
            -- This should be set by your Docker functions, but fallback to local python
            pythonPath = vim.g.python3_host_prog or vim.fn.exepath 'python3' or vim.fn.exepath 'python',
            analysis = {
              autoImportCompletions = true,
              typeCheckingMode = 'basic',
              useLibraryCodeForTypes = true,
              diagnosticMode = 'workspace',
              autoSearchPaths = true,
              extraPaths = {
                './',
                './apps/',
              },
              inlayHints = {
                functionReturnTypes = true,
                variableTypes = true,
                parameterTypes = true,
              },
            },
          },
        },
      }

      -- JavaScript/TypeScript support (for Vue)
      lspconfig.ts_ls.setup {
        capabilities = capabilities,
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      }

      -- Vue support
      lspconfig.vuels.setup {
        capabilities = capabilities,
        settings = {
          vetur = {
            validation = {
              template = true,
              script = true,
              style = true,
            },
            useWorkspaceDependencies = true,
            completion = {
              autoImport = true,
              tagCasing = 'kebab',
            },
          },
        },
      }

      -- CSS/SASS support
      lspconfig.cssls.setup {
        capabilities = capabilities,
        settings = {
          css = {
            validate = true,
            lint = {
              unknownAtRules = 'ignore',
            },
            inlayHints = {
              enabled = true,
            },
          },
          scss = {
            validate = true,
            lint = {
              unknownAtRules = 'ignore',
            },
            inlayHints = {
              enabled = true,
            },
          },
          less = {
            validate = true,
            lint = {
              unknownAtRules = 'ignore',
            },
            inlayHints = {
              enabled = true,
            },
          },
        },
      }

      -- JSON support
      lspconfig.jsonls.setup {
        capabilities = capabilities,
        settings = {
          json = {
            schemas = {
              {
                fileMatch = { 'package.json' },
                url = 'https://json.schemastore.org/package.json',
              },
              {
                fileMatch = { 'tsconfig.json', 'tsconfig.*.json' },
                url = 'https://json.schemastore.org/tsconfig.json',
              },
              {
                fileMatch = { '*.vue' },
                url = 'https://json.schemastore.org/vue.json',
              },
              {
                fileMatch = { 'pyproject.toml' },
                url = 'https://json.schemastore.org/pyproject.json',
              },
            },
            validate = { enable = true },
            format = { enable = true },
          },
        },
      }

      -- HTML support
      lspconfig.html.setup {
        capabilities = capabilities,
        settings = {
          html = {
            format = {
              templating = true,
              wrapLineLength = 120,
              wrapAttributes = 'auto',
            },
            suggest = {
              html5 = true,
            },
          },
        },
      }

      -- Lua support (for Neovim config)
      lspconfig.lua_ls.setup {
        capabilities = capabilities,
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            diagnostics = {
              globals = { 'vim' },
              disable = { 'lowercase-global', 'trailing-space', 'unused-local' },
            },
          },
        },
      }
    end,
  },

  { import = 'plugins' }, -- Load plugins from a separate file
}, {
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
