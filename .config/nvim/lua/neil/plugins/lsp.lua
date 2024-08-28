return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"folke/neodev.nvim",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",

			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/nvim-cmp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"j-hui/fidget.nvim",

			-- vscode like cmp autocompletion
			"onsails/lspkind-nvim",

			-- Autoformatting
			"stevearc/conform.nvim",

			-- Tailwind CSS
			"roobert/tailwindcss-colorizer-cmp.nvim",
		},
		config = function()
			require("neodev").setup({})
			local lsp = require("lspconfig")
			local cmp = require("cmp")
			local cmp_lsp = require("cmp_nvim_lsp")
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				cmp_lsp.default_capabilities()
			)
			local cmp_select = { behavior = cmp.SelectBehavior.Select }

			local types = require("luasnip.util.types")

			require("luasnip").setup({
				history = true,
				delete_check_events = "TextChanged",
				-- Display a cursor-like placeholder in unvisited nodes
				-- of the snippet.
				ext_opts = {
					[types.insertNode] = {
						unvisited = {
							virt_text = { { "|", "Conceal" } },
							virt_text_pos = "inline",
						},
					},
				},
			})

			require("luasnip.loaders.from_vscode").lazy_load()

			local tailwindcss_colorizer = require("tailwindcss-colorizer-cmp")
			local lspkind = require("lspkind")

			-- custom colors for cmp autocompletion and lsp documentation
			vim.cmd([[
                highlight CmpFloatBorder guibg=#1e1e1e guifg=#87ceeb
                highlight DocFloatBorder guibg=#1e1e1e guifg=#d89a1f
                highlight Pmenu guibg=#1e1e1e guifg=#cfcfcf
                highlight PmenuSel guibg=#555555 guifg=NONE
                highlight NormalFloat guibg=#1e1e1e guifg=#cfcfcf
            ]])

			cmp.setup({
				window = {
					completion = {
						-- border = "rounded",
						border = { "", "─", "╮", "│", "╯", "─", "╰", "│" },

						-- custom colors
						winhighlight = "Normal:Pmenu,FloatBorder:CmpFloatBorder,CursorLine:PmenuSel,Search:None",
					},
					documentation = {
						-- border = "rounded",
						border = { "╭", "─", "", "│", "╯", "─", "╰", "│" },
						-- custom colors
						winhighlight = "Normal:NormalFloat,FloatBorder:DocFloatBorder",
					},
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
					["<C-j>"] = cmp.mapping.select_next_item(cmp_select),

					-- select on seleted item, if not seleted, check next one
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							local selected_entry = cmp.get_selected_entry()
							if not selected_entry then
								cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
							else
								cmp.confirm({ select = true })
							end
						else
							fallback()
						end
					end, { "i", "s" }),

					["<Tab>"] = nil,
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" }, -- lsp
					{ name = "luasnip" }, -- luasnip
				}, {
					{ name = "buffer" }, -- buffer
					{ name = "path" }, -- path
				}),
				formatting = {
					-- vscode like icons for cmp autocompletion
					format = lspkind.cmp_format({
						maxwidth = 50,
						ellipsis_char = "...",
						-- prepend tailwindcss-colorizer
						-- add this line to apply color for tailwindcss cmp. if set :highlight PmenuSel will not working on current seleted item
						before = tailwindcss_colorizer.formatter,
					}),
				},
			})

			-- Global mappings
			local opts = { noremap = true, silent = true }
			vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)

			-- Use LspAttach autocommand to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),

				callback = function(ev)
					local opts = { buffer = ev.buffer, remap = false }

					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("i", "<C-a>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<C-a>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

					vim.keymap.set("n", "<leader>pd", "<cmd>Lspsaga peek_definition<CR>", opts)
					vim.keymap.set("n", "<leader>re", "<cmd>Lspsaga hover_doc<CR>", opts)
					vim.keymap.set("n", "<leader>cs", "<cmd>Lspsaga outline<CR>", opts)
					vim.keymap.set("n", "<leader>re", "<cmd>Lspsaga finder<CR>", opts)
					vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
					vim.keymap.set("n", "<F2>", "<cmd>Lspsaga rename<CR>", opts)
				end,
			})

			-- Setup LSP diagnostics
			vim.diagnostic.config({
				-- update_in_insert = true,
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = true,
					header = "",
					prefix = "",
				},
			})

			-- setup LSP diagnostics border
			-- see: https://neovim.io/doc/user/lsp.html#lsp-handlers
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				-- Use a sharp border with `FloatBorder` highlights
				border = "rounded",
				-- add the title in hover float window
				title = "Hover",
			})

			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
				-- Use a sharp border with `FloatBorder` highlights
				border = "rounded",
				title = "Signature Help",
			})

			-- diagnostic icons
			vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
			vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
			vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
			vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

			-- Format on save
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*",
				callback = function(args)
					-- if vim.bo.filetype == "vue" then
					-- 	vim.lsp.buf.format({
					-- 		bufnr = args.buf,
					-- 		timeout_ms = 1000,
					-- 		async = true,
					-- 	})
					-- 	return
					-- end
					require("conform").format({ bufnr = args.buf })
				end,
			})

			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"clangd",
					"cmake",
					"csharp_ls",
					"cssls",
					"dockerls",
					"docker_compose_language_service",
					"eslint",
					"gopls",
					"html",
					"htmx",
					"jsonls",
					"lua_ls",
					"markdown_oxide",
					"nginx_language_server",
					"pyright",
					"rust_analyzer",
					"sqls",
					"tailwindcss",
					"taplo",
					"templ",
					"terraformls",
					"tsserver",
					"vimls",
					"volar",
					"yamlls",
					"zls",
				},
			})

			-- Setup LSP handlers
			vim.filetype.add({ extension = { templ = "templ" } })

			require("mason-lspconfig").setup_handlers({
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,

				-- next, you can provide targeted overrides for specific servers.
				["lua_ls"] = function()
					lsp.lua_ls.setup({
						settings = {
							lua = {
								diagnostics = {
									globals = { "vim" },
								},
							},
						},
					})
				end,

				["gopls"] = function()
					lsp.gopls.setup({
						cmd = { "gopls", "-remote=auto" },
						settings = {
							filetypes = { "go", "gomod", "gowork", "gotmpl" },
							gopls = {
								analyses = {
									unusedparams = true,
								},
								staticcheck = true,
								usePlaceholders = false,
								completeUnimported = true,
							},
						},
					})
				end,

				["templ"] = function()
					lsp.templ.setup({})
				end,

				["tailwindcss"] = function()
					lsp.tailwindcss.setup({})
				end,

				["clangd"] = function()
					lsp.clangd.setup({
						cmd = {
							"clangd",
							-- This is a workaround to the limitations of copilot language server
							-- which only works with utf-16
							-- https://www.reddit.com/r/neovim/comments/12qbcua/multiple_different_client_offset_encodings/
							"--offset-encoding=utf-16",
						},
						filetypes = { "c", "cpp" },
						sigle_file_support = true,
					})
				end,

				["htmx"] = function()
					lsp.htmx.setup({})
				end,

				["html"] = function()
					lsp.html.setup({})
				end,

				["jsonls"] = function()
					lsp.jsonls.setup({})
				end,

				["cssls"] = function()
					lsp.cssls.setup({})
				end,

				["dockerls"] = function()
					lsp.dockerls.setup({})
				end,

				["bashls"] = function()
					lsp.bashls.setup({})
				end,

				["vimls"] = function()
					lsp.vimls.setup({})
				end,

				["yamlls"] = function()
					lsp.yamlls.setup({})
				end,

				["eslint"] = function()
					lsp.eslint.setup({})
				end,

				["pyright"] = function()
					lsp.pyright.setup({})
				end,

				-- see: https://github.com/williamboman/mason-lspconfig.nvim/issues/371#issuecomment-2188015156
				["volar"] = function()
					lsp.volar.setup({
						-- NOTE: Uncomment to enable volar in file types other than vue.
						-- (Similar to Takeover Mode)

						-- filetypes = { "vue", "javascript", "typescript", "javascriptreact", "typescriptreact", "json" },

						-- NOTE: Uncomment to restrict Volar to only Vue/Nuxt projects. This will enable Volar to work alongside other language servers (tsserver).

						-- root_dir = require("lspconfig").util.root_pattern(
						--   "vue.config.js",
						--   "vue.config.ts",
						--   "nuxt.config.js",
						--   "nuxt.config.ts"
						-- ),
						init_options = {
							vue = {
								hybridMode = false,
							},
						},
						-- NOTE: This might not be needed. Uncomment if you encounter issues.

						-- typescript = {
						--   tsdk = vim.fn.getcwd() .. "/node_modules/typescript/lib",
						-- },
					})
				end,

				-- see: https://github.com/williamboman/mason-lspconfig.nvim/issues/371#issuecomment-2188015156
				["tsserver"] = function()
					local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"
					local volar_path = mason_packages .. "/vue-language-server/node_modules/@vue/language-server"
					lsp.tsserver.setup({
						-- NOTE: To enable Hybrid Mode, change hybrideMode to true above and uncomment the following filetypes block.
						-- WARN: THIS MAY CAUSE HIGHLIGHTING ISSUES WITHIN THE TEMPLATE SCOPE WHEN TSSERVER ATTACHES TO VUE FILES

						-- filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
						init_options = {
							plugins = {
								{
									name = "@vue/typescript-plugin",
									location = volar_path,
									languages = { "vue" },
								},
							},
						},
					})
				end,

				["omnisharp"] = function()
					lsp.omnisharp.setup({})
				end,
			})

			require("conform").setup({
				-- Map of filetype to formatters
				formatters_by_ft = {
					cpp = { "clang-format" },
					c = { "clang-format" },
					lua = { "stylua" },
					-- Conform will run multiple formatters sequentially
					go = { "goimports", "gofmt" },
					-- Use a sub-list to run only the first available formatter
					javascript = { "prettierd", "prettier" },
					typescript = { "prettierd", "prettier" },
					proto = { "buf" },
					-- You can use a function here to determine the formatters dynamically
					python = { "autoflake" },
					-- vue = { "volar", "prettierd" },
					vue = { "prettierd" },
					templ = { "templ" },
					sh = { "shfmt" },
					sql = { "sql_formatter" },

					-- Use the "*" filetype to run formatters on all filetypes.
					["*"] = { "codespell" },
					-- Use the "_" filetype to run formatters on filetypes that don't
					-- have other formatters configured.
					["_"] = { "trim_whitespace" },
				},
				-- If this is set, Conform will run the formatter on save.
				-- It will pass the table to conform.format().
				-- This can also be a function that returns the table.
				format_on_save = {
					-- I recommend these options. See :help conform.format for details.
					lsp_fallback = true,
					timeout_ms = 1000,
				},
				-- If this is set, Conform will run the formatter asynchronously after save.
				-- It will pass the table to conform.format().
				-- This can also be a function that returns the table.
				format_after_save = {
					lsp_fallback = true,
				},
				-- Set the log level. Use `:ConformInfo` to see the location of the log file.
				log_level = vim.log.levels.TRACE,
				-- Conform will notify you when a formatter errors
				notify_on_error = true,
				-- Custom formatters and changes to built-in formatters
				-- formatters = {
				-- 	my_formatter = {
				-- 		-- This can be a string or a function that returns a string.
				-- 		-- When defining a new formatter, this is the only field that is *required*
				-- 		command = "my_cmd",
				-- 		-- A list of strings, or a function that returns a list of strings
				-- 		-- Return a single string instead of a list to run the command in a shell
				-- 		args = { "--stdin-from-filename", "$FILENAME" },
				-- 		-- If the formatter supports range formatting, create the range arguments here
				-- 		range_args = function(ctx)
				-- 			return { "--line-start", ctx.range.start[1], "--line-end", ctx.range["end"][1] }
				-- 		end,
				-- 		-- Send file contents to stdin, read new contents from stdout (default true)
				-- 		-- When false, will create a temp file (will appear in "$FILENAME" args). The temp
				-- 		-- file is assumed to be modified in-place by the format command.
				-- 		stdin = true,
				-- 		-- A function that calculates the directory to run the command in
				-- 		cwd = require("conform.util").root_file({ ".editorconfig", "package.json" }),
				-- 		-- When cwd is not found, don't run the formatter (default false)
				-- 		require_cwd = true,
				-- 		-- When returns false, the formatter will not be used
				-- 		condition = function(ctx)
				-- 			return vim.fs.basename(ctx.filename) ~= "README.md"
				-- 		end,
				-- 		-- Exit codes that indicate success (default { 0 })
				-- 		exit_codes = { 0, 1 },
				-- 		-- Environment variables. This can also be a function that returns a table.
				-- 		env = {
				-- 			VAR = "value",
				-- 		},
				-- 		-- Set to false to disable merging the config with the base definition
				-- 		inherit = true,
				-- 		-- When inherit = true, add these additional arguments to the command.
				-- 		-- This can also be a function, like args
				-- 		prepend_args = { "--use-tabs" },
				-- 	},
				-- 	-- These can also be a function that returns the formatter
				-- 	other_formatter = function(bufnr)
				-- 		return {
				-- 			command = "my_cmd",
				-- 		}
				-- 	end,
				-- },
			})

			-- You can set formatters_by_ft and formatters directly
			-- require("conform").formatters.my_formatter = {
			-- 	command = "my_cmd",
			-- }
		end,
	},
}
