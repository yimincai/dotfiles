return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				-- A list of parser names, or "all"
				ensure_installed = {
					"bash",
					"c",
					"cpp",
					"css",
					"csv",
					"c_sharp",
					"diff",
					"dockerfile",
					"gitignore",
					"go",
					"gomod",
					"gosum",
					"html",
					"java",
					"javascript",
					"jq",
					"json",
					"lua",
					"make",
					"markdown",
					"markdown_inline",
					"proto",
					"python",
					"query",
					"regex",
					"rust",
					"sql",
					"ssh_config",
					"tmux",
					"toml",
					"typescript",
					"vim",
					"vimdoc",
					"vue",
					"xml",
					"yaml",
				},

				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = false,

				-- Automatically install missing parsers when entering buffer
				-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
				auto_install = true,

				highlight = {
					-- `false` will disable the whole extension
					enable = true,

					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	},
}
