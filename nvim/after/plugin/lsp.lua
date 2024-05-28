local lsp = require("lspconfig")
local cmp = require("cmp")
local cmp_lsp = require("cmp_nvim_lsp")
local capabilities =
	vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())
local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
		["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
		["<Tab>"] = nil,
		["<S-Tab>"] = nil,
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" }, -- For luasnip users.
	}, {
		{ name = "buffer" },
	}),
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
		source = "always",
		header = "",
		prefix = "",
	},
})

-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
		-- local filename = vim.fn.expand("%:t")
		-- vim.notify("Formatted: " .. filename, "info", { title = "BufWritePre", timeout = 500 })
	end,
})

require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"bashls",
		"cssls",
		"dockerls",
		"gopls",
		"jsonls",
		"pyright",
		"tsserver",
		"vimls",
		"yamlls",
		"eslint",
		"volar",
		"templ",
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

	["volar"] = function()
		lsp.volar.setup({
			settings = {
				volar = {
					completion = {
						trigger = {
							triggercharacters = { ".", ":", "<", '"', "'", "/", "@" },
						},
					},
					autoimport = {
						enable = true,
					},
					indent = 4,
				},
			},
		})
	end,

	["clangd"] = function()
		lsp.clangd.setup({
			cmd = { "clangd" },
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

	["tsserver"] = function()
		lsp.tsserver.setup({})
	end,
})
