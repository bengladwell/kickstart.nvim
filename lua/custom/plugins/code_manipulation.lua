return {
  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },
  { -- treesj: Split/join blocks of code
    'Wansmer/treesj',
    keys = { '<leader>m', '<leader>M' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup {}
      vim.keymap.set('n', '<leader>m', require('treesj').toggle, { desc = 'Toggle [M]iniMap' })
      vim.keymap.set('n', '<leader>M', function()
        require('treesj').toggle { split = { recursive = true } }
      end, { desc = 'Toggle [M]iniMap (recursive)' })
    end,
  },
}
