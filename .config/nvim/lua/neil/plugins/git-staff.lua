return {
	{
		"tpope/vim-fugitive",
	},
	{

		"kdheepak/lazygit.nvim",
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function() end,
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({})
		end,
	},
}
