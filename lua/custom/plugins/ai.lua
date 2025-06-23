return {
  { 'github/copilot.vim' },
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    build = 'make',
    opts = {
      provider = 'openai',
      claude = {
        model = 'claude-sonnet-4-0',
        max_tokens = 8192,
      },
      openai = {
        model = 'gpt-4.1',
        max_tokens = 10000,
      },
      hints = { enabled = true },
      windows = {
        width = 50, -- default % based on available width
      },
      mappings = {
        sidebar = {
          switch_windows = '<F24><F24>', -- Disable by binding to a non-existent key
          reverse_switch_windows = '<F23><F23>', -- Disable by binding to a non-existent key
        },
      },
    },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-telescope/telescope.nvim',
      'hrsh7th/nvim-cmp',
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
    -- config = function()
    --   -- views can only be fully collapsed when there is a single status line,
    --   -- not one status line per split, which is what laststatus = 2 does.
    --   vim.opt.laststatus = 3
    -- end,
  },
  {
    'olimorris/codecompanion.nvim',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },
      { 'nvim-lua/plenary.nvim' },
      { 'hrsh7th/nvim-cmp' },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'codecompanion' },
        },
        ft = { 'markdown', 'codecompanion' },
      },
    },
    opts = {
      --Refer to: https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/config.lua
      strategies = {
        chat = { adapter = 'openai' },
        inline = { adapter = 'openai' },
      },
    },
  },
}
