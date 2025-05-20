return {
    {
        "williamboman/mason.nvim",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local lsp = require("lspconfig")
            local cmp_lsp = require("cmp_nvim_lsp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_lsp.default_capabilities()
            )
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "clangd",
                    "cmake",
                    -- "csharp_ls",
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
                -- ["tsserver"] = function()
                -- 	local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"
                -- 	local volar_path = mason_packages .. "/vue-language-server/node_modules/@vue/language-server"
                -- 	lsp.tsserver.setup({
                -- 		-- NOTE: To enable Hybrid Mode, change hybrideMode to true above and uncomment the following filetypes block.
                -- 		-- WARN: THIS MAY CAUSE HIGHLIGHTING ISSUES WITHIN THE TEMPLATE SCOPE WHEN TSSERVER ATTACHES TO VUE FILES

                -- 		-- filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
                -- 		init_options = {
                -- 			plugins = {
                -- 				{
                -- 					name = "@vue/typescript-plugin",
                -- 					location = volar_path,
                -- 					languages = { "vue" },
                -- 				},
                -- 			},
                -- 		},
                -- 	})
                -- end,

                ["omnisharp"] = function()
                    lsp.omnisharp.setup({})
                end,
            })
        end,
    },
}
