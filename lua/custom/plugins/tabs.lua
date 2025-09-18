return {
  { -- bufferline.nvim: Tabline
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = {
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      'EdenEast/nightfox.nvim',
    },
    config = function()
      local nightfox = require('nightfox.palette').load 'nightfox'
      require('bufferline').setup {
        options = {
          -- numbers = 'ordinal',
          diagnostics = 'nvim_lsp',
          diagnostics_indicator = function(count, level, diagnostics_dict, context)
            local icon = level:match 'error' and ' ' or ' '
            return ' ' .. icon .. count
          end,
          show_buffer_close_icons = false,
          show_close_icon = false,
          show_tab_indicators = true,
          separator_style = 'thin',
          always_show_bufferline = false,
          groups = {
            options = {
              toggle_hidden_on_enter = true,
            },
            items = {
              {
                name = 'Controllers',
                -- highlight = { underline = true, sp = 'gray' },
                matcher = function(buf)
                  return buf.path and buf.path:match 'app/controllers/.*%.rb'
                end,
                auto_close = false,
              },
              {
                name = 'Models',
                highlight = { sp = nightfox.red.dim },
                matcher = function(buf)
                  return buf.path and buf.path:match 'app/models/.*%.rb'
                end,
                auto_close = false,
              },
              {
                name = 'Views',
                highlight = { sp = nightfox.green.dim },
                matcher = function(buf)
                  return buf.path and buf.path:match 'app/views/.*%.slim'
                end,
                auto_close = false,
              },
              {
                name = 'Stimulus',
                highlight = { sp = nightfox.yellow.dim },
                matcher = function(buf)
                  return buf.path and buf.path:match 'app/javascript/controllers/.*%.js'
                end,
                auto_close = false,
              },
            },
          },
          custom_filter = function(buf_number, buf_numbers)
            if vim.bo[buf_number].buftype == 'quickfix' then
              return false
            end
            return true
          end,
        },
      }
      local map = vim.api.nvim_set_keymap
      local opts = { noremap = true, silent = true }
      -- Move to previous/next
      map('n', '<A-,>', ':BufferLineCyclePrev<CR>', opts)
      map('n', '<A-.>', ':BufferLineCycleNext<CR>', opts)
      -- Re-order to previous/next
      map('n', '<A-Left>', ':BufferLineMovePrev<CR>', opts)
      map('n', '<A-Right>', ':BufferLineMoveNext<CR>', opts)
      map('n', '<leader>p', ':BufferLinePick<CR>', opts)
    end,
  },
}
