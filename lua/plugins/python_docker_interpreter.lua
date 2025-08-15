return {
  url = 'git@github.com:joCaldwell/neovim-docker-python-interpreter.nvim.git', --'joCaldwell/neovim-python-docker-interpreter.nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
    'nvim-lua/plenary.nvim', -- optional but recommended
  },
  config = function()
    require('docker_python_interpreter').setup {
      -- Docker configuration
      docker = {
        service = 'web', -- Your docker-compose service name
        workdir = '/srv/app', -- Working directory inside container
        compose_cmd = { 'docker', 'compose' }, -- Command to run docker compose
        auto_install_pyright = true, -- Auto-install Pyright in container
        health_check_interval = 300, -- Health check interval in seconds (0 to disable)
        path_map = {
          container_root = '/srv/app', -- Root path in container
          host_root = nil, -- Root path on host (nil = auto-detect)
        },
      },

      -- Pyright LSP settings
      pyright_settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = 'workspace',
            typeCheckingMode = 'basic',
          },
        },
      },

      -- Plugin behavior
      auto_select = false, -- Auto-select interpreter if only one available
      prefer_docker = false, -- Prefer Docker over local when both available
      cache_ttl = 60, -- Cache discovery results for N seconds

      -- Optional: Custom on_attach function for LSP
      on_attach = function(client, bufnr)
        -- Your custom LSP keybindings/settings
      end,
    }
  end,
}
