return {
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
		config = function()
			require("oil").setup({
				columns = {
					"icon",
					-- "permissions",
					-- "size",
					-- "mtime",
				},
				view_options = {
					show_hidden = true,
				},
			})

			-- open parent directory in new floating window
			vim.keymap.set("n", "<space>-", require("oil").toggle_float)
		end,
	},
}
