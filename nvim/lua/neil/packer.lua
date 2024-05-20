-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd.packadd("packer.nvim")

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")
	use("lukas-reineke/indent-blankline.nvim")
	use({ "folke/todo-comments.nvim", requires = "nvim-lua/plenary.nvim" })
	use("rcarriga/nvim-notify")
	use("stevearc/conform.nvim")
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.x",
		-- or                            , branch = '0.1.x',
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	-- neoconf
	use({ "folke/neoconf.nvim" })

	use({ "laytan/cloak.nvim" })

	-- status bar
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "nvim-tree/nvim-web-devicons", opt = true },
	})
	-- themes
	use({ "catppuccin/nvim" })
	use({ "olimorris/onedarkpro.nvim" })
	use({ "folke/tokyonight.nvim" })
	use({ "rose-pine/neovim" })
	use({ "ellisonleao/gruvbox.nvim" })
	use({ "rebelot/kanagawa.nvim" })

	-- comments
	-- use({
	-- 	"numToStr/Comment.nvim",
	-- })
	use("terrortylor/nvim-comment")

	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
	use("nvim-treesitter/playground")
	use("mbbill/undotree")
	use("tpope/vim-fugitive")
	use("nvim-treesitter/nvim-treesitter-context")
	use({
		"akinsho/toggleterm.nvim",
		tag = "*",
		config = function()
			require("toggleterm").setup()
		end,
	})

	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})

	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons", -- optional
		},
	})

	use({
		"kdheepak/lazygit.nvim",
		-- optional for floating window border decoration
		requires = {
			"nvim-lua/plenary.nvim",
		},
	})

	use({
		"neovim/nvim-lspconfig",
		requires = {
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline" },
			{ "hrsh7th/nvim-cmp" },
			{ "L3MON4D3/LuaSnip" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "j-hui/fidget.nvim" },
		},
	})

	use({
		"nvimdev/lspsaga.nvim",
		requires = { "nvim-lspconfig" },
	})

	-- debugger
	use("folke/neodev.nvim")
	use("nvim-neotest/nvim-nio")
	use({
		"rcarriga/nvim-dap-ui",
		requires = { "mfussenegger/nvim-dap" },
	})
	use("theHamsta/nvim-dap-virtual-text")
	use("leoluz/nvim-dap-go")

	use("folke/zen-mode.nvim")
	use("github/copilot.vim")
	use("eandrju/cellular-automaton.nvim")
	use("folke/trouble.nvim")

	-- These optional plugins should be loaded directly because of a bug in Packer lazy loading
	use("nvim-tree/nvim-web-devicons") -- OPTIONAL: for file icons
	use("lewis6991/gitsigns.nvim") -- OPTIONAL: for git status
	use("romgrk/barbar.nvim")

	-- color
	use("norcalli/nvim-colorizer.lua")
end)
