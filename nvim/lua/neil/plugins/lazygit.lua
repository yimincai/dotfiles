return {
	{

		"kdheepak/lazygit.nvim",
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			vim.api.nvim_set_keymap("n", "<leader>aa", "<cmd>:LazyGit<cr>", { noremap = true, silent = true })
		end,
	},
}
