return {
	{
		"rcarriga/nvim-notify",
		config = function()
			require("notify").setup({
				-- background_colour = "NotifyBackground",
				-- background_colour = "#00000080",
				background_colour = "#00000000",
				-- background_colour = "#00000080", fps = 30,
				icons = {
					DEBUG = "",
					ERROR = "",
					INFO = "",
					TRACE = "✎",
					WARN = "",
				},
				level = 2,
				minimum_width = 30,
				render = "minimal",
				stages = "slide",
				time_formats = {
					notification = "%T",
					notification_history = "%FT%T",
				},
				timeout = 1000,
				top_down = true,
			})
		end,
	},
}
