-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    -- 'leoluz/nvim-dap-go',
    'mfussenegger/nvim-dap-python',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<F5>',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: Start/Continue',
    },
    {
      '<F6>',
      function()
        require('dap').run_to_cursor()
      end,
      desc = 'Debug: Run To Cursor',
    },
    {
      '<F7>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F8>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<S-F8>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>b',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle Breakpoint',
    },
    {
      '<leader>B',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set Breakpoint',
    },
    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    {
      '<F9>',
      function()
        require('dapui').toggle()
      end,
      desc = 'Debug: Toggle DAP UI',
    },
    {
      '<F10>',
      function()
        require('dapui').eval()
      end,
      mode = { 'n', 'v' },
      desc = 'Debug: Eval',
    },
    {
      '<F2>',
      function()
        require('dap.ui.widgets').preview()
      end,
      desc = 'Debug: Preview',
    },
    {
      '<F3>',
      function()
        require('dap.ui.widgets').hover()
      end,
      desc = 'Debug: Hover',
    },
    {
      '<F11>',
      function()
        require('dap').disconnect()
      end,
      desc = 'Debug: Disconnect',
    },
    {
      '<F12>',
      function()
        require('dap').disconnect { terminateDebuggee = true }
      end,
      desc = 'Debug: Disconnect and terminate',
    },
    {
      '<leader>td',
      function()
        require('dap-python').test_method()
      end,
      desc = 'Test Nearest with [D]ebugging',
    },
  },
  -- From old config:
  --     vim.keymap.set('n', '<leader>dp', function()
  --       require('dap.ui.widgets').preview()
  --     end, { desc = '[D]ebug [P]review' })
  --     vim.keymap.set('n', '<leader>dh', function()
  --       require('dap.ui.widgets').hover()
  --     end, { desc = '[D]ebug [H]over' })
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    dap.set_log_level 'DEBUG'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
      },
    }

    local local_dap_config = vim.fn.getcwd() .. '/.nvim/dap.lua'

    -- Setup DAP config per project directory using <ROOT>/.nvim/dap.lua.
    -- Example ruby setup:
    -- In <ROOT>/.nvim/dap.lua:
    -- ```lua`
    -- local dap = require("dap")
    --
    -- dap.adapters.ruby = function(on_config, config)
    --   on_config({
    --     type = "pipe",
    --     pipe = config.pipe,
    --   })
    -- end
    --
    -- dap.adapters.rspec_at_line = function(on_config, config)
    --   on_config({
    --     type = "pipe",
    --     pipe = "${pipe}",
    --     executable = {
    --       command = "rdbg",
    --       args = { "--open", "--sock-path", "${pipe}", "-c", "--", "bundle", "exec", "rspec", config.file },
    --     },
    --   })
    -- end
    --
    -- dap.adapters.ruby_script = function(on_config, config)
    --   on_config({
    --     type = "pipe",
    --     pipe = "${pipe}",
    --     executable = {
    --       command = "rdbg",
    --       args = { "--open", "--sock-path", "${pipe}", "-c", "--", "ruby", config.program },
    --     },
    --   })
    -- end
    --
    -- dap.configurations.ruby = {
    --   {
    --     type = "ruby",
    --     request = "attach",
    --     name = "Debug Puma",
    --     pipe = vim.fn.getcwd() .. "/tmp/puma_debug.sock",
    --   },
    --   {
    --     type = "ruby",
    --     request = "attach",
    --     name = "Debug Sidekiq",
    --     pipe = vim.fn.getcwd() .. "/tmp/sidekiq_debug.sock",
    --   },
    --   {
    --     type = "rspec_at_line",
    --     name = "Test At Line",
    --     request = "launch",
    --     file = function()
    --       local file_path = vim.fn.expand("%:p")
    --       local current_line = vim.fn.line(".")
    --       return file_path .. ":" .. current_line
    --     end,
    --   },
    --   {
    --     type = "ruby_script",
    --     name = "Run Current Buffer",
    --     program = "${file}",
    --     request = "launch",
    --     console = "integratedTerminal",
    --   },
    -- }
    --
    -- -- Make the function global so it can be called from the keymap
    -- _G.debug_rspec = function()
    --   for _, config in pairs(dap.configurations.ruby) do
    --     if config.name == "Test At Line" then
    --       dap.run(config)
    --       return
    --     end
    --   end
    -- end
    --
    -- vim.api.nvim_set_keymap("n", "<leader>td", "<cmd>lua debug_rspec()<CR>", { noremap = true, silent = true })
    -- ```
    -- In Procfile.debug:
    -- ```
    -- web: bin/rdbg -n -O --sock-path ./tmp/puma_debug.sock -c -- bundle exec puma -C config/puma.rb -p 3000
    -- jobs: bin/rdbg -n -O --sock-path ./tmp/sidekiq_debug.sock -c -- bundle exec sidekiq -C config/sidekiq.yml
    -- ```
    -- Example python setup:
    -- In this setup, we stop an existing service and start the service with the debuggee from the DAP menu.
    -- In <ROOT>/.nvim/dap.lua:
    -- ```lua`
    -- local dap = require("dap")
    -- require("dap-python").setup("uv")
    --
    -- -- Common configuration for Python debug configurations
    -- local common_config = {
    --   type = "python",
    --   request = "launch",
    --   -- python = { os.getenv("HOME") .. "/dev/spx/astrology/.venv/bin/python", "-Xfrozen_modules=off" },
    --   env = {
    --     DOPPLER_ENV = "1",
    --     DATABASE_PORT = "5432",
    --     ASTROLOGY_PORT = "8001",
    --     ASTROLOGY_REDIS_URL = "redis://localhost:6379/2",
    --     ASTROLOGY_STORAGE_PATH = "/Users/bgladwell/dev/spx/rcis-workspace/storage",
    --     ASTROLOGY_PIDS_PATH = "/Users/bgladwell/dev/spx/rcis-workspace/tmp/pids",
    --   },
    --   justMyCode = false,
    --   console = "integratedTerminal",
    -- }
    --
    -- dap.configurations.python = {
    --   vim.tbl_deep_extend("force", common_config, {
    --     name = "Debug FastAPI",
    --     code = "from app.main import dev_start; dev_start()",
    --   }),
    --   vim.tbl_deep_extend("force", common_config, {
    --     name = "Debug Dramatiq",
    --     code = "from app.dramatiq.worker import dev_start; dev_start()",
    --   }),
    --   vim.tbl_deep_extend("force", common_config, {
    --     name = "Run Current Buffer",
    --     program = "${file}",
    --     request = "launch",
    --     type = "python",
    --     console = "integratedTerminal",
    --   }),
    -- }
    -- ````

    if vim.fn.filereadable(local_dap_config) == 1 then
      -- vim.notify('Sourcing local DAP config: ' .. local_dap_config, 'info')
      dofile(local_dap_config)
    end

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    -- Change breakpoint icons
    -- vim.fn.sign_define('DapBreakpoint', { text = '📍', texthl = '', linehl = '', numhl = '' })
    -- vim.fn.sign_define('DapStopped', { text = '⚠️', texthl = '', linehl = '', numhl = '' })
    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    local breakpoint_icons = vim.g.have_nerd_font
        and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
      or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    for type, icon in pairs(breakpoint_icons) do
      local tp = 'Dap' .. type
      local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
      vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end

    dap.listeners.before.attach.dapui_config = dapui.open
    dap.listeners.before.launch.dapui_config = dapui.open
    dap.listeners.before.event_terminated.dapui_config = dapui.close
    dap.listeners.before.event_exited.dapui_config = dapui.close
    dap.listeners.before.event_stopped.dapui_config = dapui.open

    -- Install golang specific config
    -- require('dap-go').setup {
    --   delve = {
    --     -- On Windows delve must be run attached or it crashes.
    --     -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
    --     detached = vim.fn.has 'win32' == 0,
    --   },
    -- }
  end,
}
