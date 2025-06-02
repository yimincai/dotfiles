local default_opts = { noremap = true }
local default_silent_opts = { noremap = true, silent = true }
local notify = require("notify")

-- show prev view
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.api.nvim_set_keymap("i", "jk", "<Esc>", default_silent_opts)
-- 使用 <F1> 切換到下一個文檔
vim.api.nvim_set_keymap("n", "<F1>", ":bnext<CR>", default_silent_opts)
-- 使用 <F1> 切換到前一個文檔
vim.api.nvim_set_keymap("n", "<F1>", ":bprev<CR>", default_silent_opts)
-- 使用 <F3> 交換當前視窗和下一個視窗的位置
vim.api.nvim_set_keymap("n", "<F3>", "<C-w>x", default_silent_opts)
-- 切換所有分割視窗的方向（水平 <-> 垂直）
-- 使用 Ctrl+Shift--hjkl 來調整視窗大小
vim.api.nvim_set_keymap("n", "<C-S-h>", "<C-w><", default_silent_opts) -- shrink width
vim.api.nvim_set_keymap("n", "<C-S-j>", "<C-w>+", default_silent_opts) -- enlarge height
vim.api.nvim_set_keymap("n", "<C-S-k>", "<C-w>-", default_silent_opts) -- shrink height
vim.api.nvim_set_keymap("n", "<C-S-l>", "<C-w>>", default_silent_opts) -- enlarge width

-- use Ctrl-hjkl to switch between windows
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", default_silent_opts)
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", default_silent_opts)
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", default_silent_opts)
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", default_silent_opts)
-- next window
vim.api.nvim_set_keymap("n", "<C-n>", "<C-w>w", default_silent_opts)
-- previous window
vim.api.nvim_set_keymap("n", "<C-p>", "<C-w>p", default_silent_opts)

-- Split window
vim.api.nvim_set_keymap("n", "<leader>v", ":vsplit<CR>", default_silent_opts)
vim.api.nvim_set_keymap("n", "<leader>s", ":split<CR>", default_silent_opts)

-- lsp restart
vim.keymap.set("n", "<leader>R", function()
	vim.cmd("LspRestart")
	notify("Language server restarted", "info", {
		title = "LSP",
	})
end)

-- Copilot
vim.g.copilot_assume_mapped = true

-- Clipboard
-- vim.api.nvim_set_keymap("n", "<leader>y", '"+y<CR>', { noremap = true })
-- vim.api.nvim_set_keymap("x", "<leader>y", '"+y<CR>', { noremap = true })

-- Celluar Automaton
vim.keymap.set("n", "<leader>wtf", ":CellularAutomaton make_it_rain<CR>")
vim.keymap.set("n", "<leader>wtff", ":CellularAutomaton game_of_life<CR>")

-- Todo comment
vim.keymap.set("n", "<leader>td", "<cmd>TodoTelescope<CR>")

-- Nvim tree
vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true })

-- Fold
-- Key mappings for folding and unfolding
vim.api.nvim_set_keymap("n", "zj", ":foldopen!<CR>", default_silent_opts) -- fold open cursor
vim.api.nvim_set_keymap("n", "zk", ":foldclose!<CR>", default_silent_opts) -- fold close cursor
-- enable or disable fold
vim.keymap.set("n", "<leader>zm", function()
	if vim.wo.foldenable then
		vim.opt.foldenable = false
		vim.opt.foldlevel = 99
		notify("Fold disable", "info", {
			title = "Editor",
		})
	else
		vim.opt.foldenable = true
		vim.opt.foldlevel = 0
		notify("Fold enable", "info", {
			title = "Editor",
		})
	end
end)

-- Telescoperema
vim.api.nvim_set_keymap("n", "<leader>ff", "<cmd>lua require'telescope.builtin'.find_files()<cr>", default_opts)
vim.api.nvim_set_keymap(
	"n",
	"<leader>as",
	"<cmd>lua require'telescope.builtin'.buffers({ show_all_buffers = true })<cr>",
	default_opts
)
vim.api.nvim_set_keymap("n", "<leader>fg", "<cmd>lua require'telescope.builtin'.git_status()<cr>", default_opts)
vim.api.nvim_set_keymap("n", "<leader>td", ":TodoTelescope<cr>", default_opts)
-- vim.api.nvim_set_keymap('n', '<leader>/', ":silent grep ", default_opts)
vim.api.nvim_set_keymap("n", "<leader>tg", "<cmd>lua require'telescope.builtin'.live_grep()<cr>", default_opts)

-- Lazygit
vim.api.nvim_set_keymap("n", "<leader>aa", "<cmd>:LazyGit<cr>", default_silent_opts)

-- Gitsigns
vim.api.nvim_set_keymap("n", "<leader>hh", ":Gitsigns preview_hunk<CR>", default_silent_opts)
vim.api.nvim_set_keymap("n", "<leader>hs", ":Gitsigns stage_hunk<CR>", default_silent_opts)
vim.api.nvim_set_keymap("n", "<leader>hu", ":Gitsigns undo_stage_hunk<CR>", default_silent_opts)
vim.api.nvim_set_keymap("n", "<leader>hr", ":Gitsigns reset_hunk<CR>", default_silent_opts)
vim.api.nvim_set_keymap("n", "<leader>hR", ":Gitsigns reset_buffer<CR>", default_silent_opts)
vim.api.nvim_set_keymap("n", "<leader>hd", ":vertical Gitsigns diffthis<CR>", default_silent_opts)
vim.api.nvim_set_keymap("n", "<leader>hD", ":Gitsigns diffthis<CR>", default_silent_opts)
vim.api.nvim_set_keymap("n", "<leader>hb", ":Gitsigns blame<CR>", default_silent_opts)
-- Fugitive
vim.keymap.set("n", "<leader>gs", ":G status<CR>", default_silent_opts)
vim.keymap.set("n", "<leader>gl", ":G log<CR>", default_silent_opts)
-- vim.keymap.set("n", "<leader>gb", ":G blame<CR>", default_silent_opts)
vim.keymap.set("n", "<leader>gD", ":Gvdiffsplit<CR>", default_silent_opts)

-- DiffView
vim.keymap.set("n", "<leader>dv", ":DiffviewOpen<CR>", default_silent_opts)

-- testing
vim.keymap.set("n", "<leader>tt", function()
	if vim.bo.filetype == "go" then
		vim.cmd("GoTestFile")
		notify("Running GoTestFile", "info", {
			title = "Golang",
		})
	else
		notify("This filetype not supported for test file", "error", {
			title = "Golang",
		})
	end
end)

vim.keymap.set("n", "<leader>tc", function()
	if vim.bo.filetype == "go" then
		vim.cmd("GoTestFunc")
		notify("Running GoTestFunc", "info", {
			title = "Golang",
		})
	else
		notify("This filetype not supported for test function", "error", {
			title = "Golang",
		})
	end
end)

vim.keymap.set("n", "<leader>tp", function()
	if vim.bo.filetype == "go" then
		vim.cmd("GoTestPkg")
		notify("Running GoTestPkg", "info", {
			title = "Golang",
		})
	else
		notify("This filetype not supported for test pkg", "error", {
			title = "Golang",
		})
	end
end)

vim.keymap.set("n", "<leader>ta", function()
	if vim.bo.filetype == "go" then
		vim.cmd("GoTestSum")
		notify("Running GoTestSum", "info", {
			title = "Golang",
		})
	else
		notify("This filetype not supported for test sum", "error", {
			title = "Golang",
		})
	end
end)
