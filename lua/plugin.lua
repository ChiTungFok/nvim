local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    {
        'kyazdani42/nvim-tree.lua',
        dependencies = {'kyazdani42/nvim-web-devicons', 'nvim-web-devicons'} ,
    },

    'windwp/nvim-autopairs',

    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

    'numToStr/Comment.nvim',

    {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
            "neovim/nvim-lspconfig",
            "SmiteshP/nvim-navic",
            "MunifTanjim/nui.nvim",
            "numToStr/Comment.nvim",        -- Optional
            "nvim-telescope/telescope.nvim" -- Optional
        }
    },

    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            {'nvim-lua/plenary.nvim'},
            {'nvim-telescope/telescope-live-grep-args.nvim'},
            {'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        },
        config = function(plugin)
            require('telescope').load_extension('fzf')
            require("telescope").load_extension("live_grep_args")
        end
    },

    { 'sindrets/diffview.nvim', dependencies = 'nvim-lua/plenary.nvim' },

    'lewis6991/gitsigns.nvim',

    { 'catppuccin/nvim', name = 'catppuccin' },
    'folke/tokyonight.nvim',
    "AstroNvim/astrotheme",

    {
        "olimorris/onedarkpro.nvim",
        priority = 1000 -- Ensure it loads first
    },

    'neovim/nvim-lspconfig',

    'hrsh7th/nvim-cmp', -- Autocompletion plugin
    'hrsh7th/cmp-nvim-lsp', -- LSP source for nvim-cmp

    'saadparwaiz1/cmp_luasnip', -- Snippets source for nvim-cmp
    'L3MON4D3/LuaSnip', -- Snippets plugin
}

return require('lazy').setup(plugins)
