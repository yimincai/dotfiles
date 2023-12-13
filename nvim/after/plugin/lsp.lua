local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({
    'tsserver',
    'rust_analyzer',
})


lsp.configure('gopls', {
    settings = {
        filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
            usePlaceholders = true,
            completeUnimported = true,
        },
    },
})

-- Fix Undefined global 'vim'
lsp.configure('lua-language-server', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})


local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
    },
})

-- Set same diagnostic window to cmp.config.window.bordered()
vim.cmd(':set winhighlight=' .. cmp.config.window.bordered().winhighlight)

cmp_mappings['<Tab>'] = nil
cmp_mappings['<S-Tab>'] = nil

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.set_preferences({
    suggest_lsp_servers = false,
})

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>pd", "<cmd>Lspsaga peek_definition<CR>",
        { silent = true, noremap = true })
    vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, opts)
    vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts)
    -- vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>re", "<cmd>Lspsaga hover_doc<CR>", { silent = true, noremap = true })
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    -- vim.keymap.set("n", "<leader>cc", function() vim.lsp.buf.code_action() end, opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>cc", "<cmd>Lspsaga code_action<CR>",
        { silent = true, noremap = true })
    -- call hiierarchy
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>cs", "<cmd>Lspsaga outgoing_calls<CR>", {silent = true, noremap = true})
    -- outline
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>cs", "<cmd>Lspsaga outline<CR>", { silent = true, noremap = true })
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>re", "<cmd>Lspsaga finder<CR>", { silent = true, noremap = true })
    -- diagnostic
    -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>z", "<cmd>Lspsaga show_workspace_diagostics<CR>",
    -- { silent = true, noremap = true })
    -- vim.keymap.set("n", "<leader>re", function() vim.lsp.buf.references() end, opts)
    -- vim.keymap.set("n", "<F2>", function() vim.lsp.buf.rename() end, opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<F2>", "<cmd>Lspsaga rename<CR>", { silent = true, noremap = true })

    vim.keymap.set("i", "<C-a>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})
