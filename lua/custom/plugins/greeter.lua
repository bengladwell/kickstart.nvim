return {
  { -- alpha-nvim: greeter page
    'goolord/alpha-nvim', -- Greeter
    dependencies = {
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('alpha').setup(require('alpha.themes.startify').config)
    end,
  },
}
