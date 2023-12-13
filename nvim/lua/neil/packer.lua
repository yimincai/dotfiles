-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    use 'lukas-reineke/indent-blankline.nvim'
    use 'j-hui/fidget.nvim'
    use { 'folke/todo-comments.nvim', requires = 'nvim-lua/plenary.nvim' }
    use 'rcarriga/nvim-notify'
    use 'stevearc/conform.nvim'
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.x',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    -- themes
    use { 'catppuccin/nvim' }
    use { 'olimorris/onedarkpro.nvim' }
    use { 'folke/tokyonight.nvim' }
    use({ 'rose-pine/neovim' })
    --	themes

    -- comments
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

    use({ 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' })
    use('nvim-treesitter/playground')
    use('mbbill/undotree')
    use('tpope/vim-fugitive')
    use('nvim-treesitter/nvim-treesitter-context');
    use { 'akinsho/toggleterm.nvim', tag = '*', config = function()
        require('toggleterm').setup()
    end }

    use {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup {
            }
        end
    }

    use {
        'nvim-neo-tree/neo-tree.nvim',
        version = '*',
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
            'MunifTanjim/nui.nvim',
            -- '3rd/image.nvim', -- Optional image support in preview window: See `# Preview Mode` for more information
        }
    }

    use({
        'kdheepak/lazygit.nvim',
        -- optional for floating window border decoration
        requires = {
            'nvim-lua/plenary.nvim',
        },
    })

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    }

    use({
        'nvimdev/lspsaga.nvim',
        requires = { 'nvim-lspconfig' },
    })


    -- debuger
    use 'folke/neodev.nvim'
    use({
        'rcarriga/nvim-dap-ui',
        requires = { 'mfussenegger/nvim-dap' },
    })
    use 'theHamsta/nvim-dap-virtual-text'
    use 'leoluz/nvim-dap-go'
    require('dap-go').setup()


    use('folke/zen-mode.nvim')
    use('github/copilot.vim')
    use('eandrju/cellular-automaton.nvim')
    use('folke/trouble.nvim')
    -- These optional plugins should be loaded directly because of a bug in Packer lazy loading
    use 'nvim-tree/nvim-web-devicons' -- OPTIONAL: for file icons
    use 'lewis6991/gitsigns.nvim'     -- OPTIONAL: for git status
    use 'romgrk/barbar.nvim'
end)
