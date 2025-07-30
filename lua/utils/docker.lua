local MODULE = {}

-- Function to create a wrapper script for Pyright
function MODULE.create_pyright_wrapper()
  local service_name = vim.g.docker_service_name or 'web'
  local wrapper_content = string.format(
    [[#!/bin/bash
docker compose exec -T %s python -m pyright "$@"
]],
    service_name
  )

  local wrapper_path = vim.fn.stdpath 'cache' .. '/pyright-docker'
  local file = io.open(wrapper_path, 'w')
  if file then
    file:write(wrapper_content)
    file:close()

    -- Make it executable
    os.execute('chmod +x ' .. wrapper_path)

    if vim.g.docker_debug then
      print('Created Pyright wrapper at: ' .. wrapper_path)
    end
    return wrapper_path
  end

  return nil
end

-- Setup function that uses the wrapper to run Pyright inside Docker
function MODULE.setup_pyright(lspconfig, capabilities)
  local wrapper_path = MODULE.create_pyright_wrapper()
  if wrapper_path then
    lspconfig.pyright.setup {
      capabilities = capabilities,
      cmd = { wrapper_path, '--stdio' },
      settings = {
        python = {
          analysis = {
            autoImportCompletions = true,
            typeCheckingMode = 'basic',
            useLibraryCodeForTypes = true,
            diagnosticMode = 'workspace',
            autoSearchPaths = true,
            extraPaths = { './', './apps/' },
            inlayHints = {
              functionReturnTypes = true,
              variableTypes = true,
              parameterTypes = true,
            },
          },
        },
      },
      commands = {
        RefreshPythonPath = {
          function()
            -- Recreate the wrapper and restart the LSP client
            local new_wrapper_path = MODULE.create_pyright_wrapper()
            if new_wrapper_path then
              -- Restart Pyright
              vim.cmd 'LspRestart pyright'
              print 'Refreshed Pyright Docker wrapper'
            end
          end,
          description = 'Refresh Docker Pyright wrapper',
        },
      },
    }
  else
    print 'Failed to create Pyright wrapper, falling back to default setup'
    lspconfig.pyright.setup {
      capabilities = capabilities,
      settings = {
        python = {
          analysis = {
            extraPaths = { './', './apps/' },
          },
        },
      },
    }
  end
end

-- Function to run Pyright directly inside Docker (alternative method)
function MODULE.setup_pyright_direct(lspconfig, capabilities)
  local service_name = vim.g.docker_service_name or 'web'

  lspconfig.pyright.setup {
    capabilities = capabilities,
    cmd = {
      'docker',
      'compose',
      'exec',
      '-T',
      service_name,
      'python',
      '-m',
      'pyright',
      '--stdio',
    },
    settings = {
      python = {
        analysis = {
          autoImportCompletions = true,
          typeCheckingMode = 'basic',
          useLibraryCodeForTypes = true,
          diagnosticMode = 'workspace',
          autoSearchPaths = true,
          extraPaths = { './', './apps/' },
          inlayHints = {
            functionReturnTypes = true,
            variableTypes = true,
            parameterTypes = true,
          },
        },
      },
    },
  }
end

-- Function to create user commands
function MODULE.create_commands()
  vim.api.nvim_create_user_command('DockerPythonTest', function()
    local service_name = vim.g.docker_service_name or 'web'
    print 'Testing Docker Python environment...'

    -- Test basic Python
    local handle = io.popen('docker compose exec -T ' .. service_name .. ' python --version 2>/dev/null')
    if handle then
      local version = handle:read('*a'):gsub('%s+', '')
      handle:close()
      if version and version ~= '' then
        print('Python version: ' .. version)
      else
        print 'Failed to get Python version'
      end
    end

    -- Test Django import
    handle = io.popen('docker compose exec -T ' .. service_name .. ' python -c "import django; print(\\"Django version:\\", django.VERSION)" 2>/dev/null')
    if handle then
      local django_info = handle:read('*a'):gsub('%s+', '')
      handle:close()
      if django_info and django_info ~= '' then
        print(django_info)
      else
        print 'Failed to import Django'
      end
    end

    -- Test if Pyright is available
    handle = io.popen('docker compose exec -T ' .. service_name .. ' python -m pyright --version 2>/dev/null')
    if handle then
      local pyright_version = handle:read('*a'):gsub('%s+', '')
      handle:close()
      if pyright_version and pyright_version ~= '' then
        print('Pyright version: ' .. pyright_version)
      else
        print 'Pyright not found in container - you may need to install it'
        print('Run: docker compose exec ' .. service_name .. ' pip install pyright')
      end
    end
  end, { desc = 'Test Docker Python environment' })

  vim.api.nvim_create_user_command('DockerRefreshPyright', function()
    local clients = vim.lsp.get_active_clients { name = 'pyright' }
    for _, client in ipairs(clients) do
      client.stop()
    end
    vim.cmd 'LspStart pyright'
    print 'Restarted Pyright'
  end, { desc = 'Restart Pyright LSP' })
end

return MODULE
