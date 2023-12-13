vim.notify = require("notify")

-- show prev view
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { noremap = true, silent = true })
-- 使用 <F1> 切換到下一個文檔
vim.api.nvim_set_keymap('n', '<F1>', ':bnext<CR>', { noremap = true, silent = true })
-- 使用 <F1> 切換到前一個文檔
vim.api.nvim_set_keymap('n', '<F1>', ':bprev<CR>', { noremap = true, silent = true })

-- use Ctrl-hjkl to switch between windows
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

-- 使用 <F2> 交換當前視窗和下一個視窗的位置
vim.api.nvim_set_keymap('n', '<F3>', '<C-w>x', { noremap = true, silent = true })

-- lsp format
-- vim.keymap.set("n", "<leader>f", function()
--     vim.lsp.buf.format()
--     vim.cmd("write")
--     vim.notify("Formatted and Saved", "info", { title = "LSP" })
-- end)

-- lsp format
vim.keymap.set("n", "<leader>f", function()
    vim.cmd("write")
end)


-- lsp restart
vim.keymap.set("n", "<leader>R", function()
    vim.cmd("LspRestart")
    vim.notify("Lsp Restarted", "info", { title = "LSP" })
end)

-- Copilot
vim.g.copilot_assume_mapped = true

-- Clipboard
vim.api.nvim_set_keymap('n', '<leader>y', '"+y<CR>', { noremap = true })
vim.api.nvim_set_keymap('x', '<leader>y', '"+y<CR>', { noremap = true })

-- Trouble
vim.keymap.set('n', '<leader>q', function() require("trouble").toggle() end)

-- Celluar Automaton
vim.keymap.set("n", "<leader>wtf", "<cmd>CellularAutomaton make_it_rain<CR>")
vim.keymap.set("n", "<leader>love", "<cmd>CellularAutomaton game_of_life<CR>")

-- Todo comment
vim.keymap.set("n", "<leader>td", "<cmd>TodoTelescope<CR>")

-- Debuger
vim.api.nvim_set_keymap("n", "<leader>dt", ":lua require('dapui').open()<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>ds", ":lua require('dapui').close()<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>db", ":DapToggleBreakpoint<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>dc", ":DapContinue<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>dr", ":lua require('dapui').open({reset=true})<CR>", { noremap = true })

-- Fold
-- Key mappings for folding and unfolding
-- vim.api.nvim_set_keymap('n', '<leader>zo', ':foldopen<CR>', { noremap = true, silent = true })   -- fold open (under the cursor)
vim.api.nvim_set_keymap('n', 'zj', ':foldopen!<CR>', { noremap = true, silent = true })  -- fold open all
-- vim.api.nvim_set_keymap('n', '<leader>zc', ':foldclose<CR>', { noremap = true, silent = true })  -- fold close
vim.api.nvim_set_keymap('n', 'zk', ':foldclose!<CR>', { noremap = true, silent = true }) -- fold close all
