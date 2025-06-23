return {
  {
    'vim-test/vim-test',
    dependencies = {
      'tpope/vim-dispatch',
    },
    config = function()
      vim.keymap.set('n', '<leader>T', ':TestFile<CR>', { desc = 'Test [T]est' })
      vim.keymap.set('n', '<leader>tn', ':TestNearest<CR>', { desc = 'Test [N]earest' }) -- NO!
      vim.keymap.set('n', '<leader>l', ':TestLast<CR>', { desc = 'Test [L]ast' })
      -- vim.keymap.set('n', '<leader>a', ':TestSuite<CR>', { desc = 'Test [S]uite' })
      vim.keymap.set('n', '<leader>g', ':TestVisit<CR>', { desc = 'Test [V]isit' })
      vim.g['test#strategy'] = 'toggleterm'
      vim.g['test#python#pytest#executable'] = 'uv run pytest -s --disable-warnings'
      vim.g['slimux_select_from_current_window'] = 1
    end,
  },
}
