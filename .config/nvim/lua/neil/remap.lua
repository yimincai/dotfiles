-- show prev view
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.api.nvim_set_keymap("i", "jk", "<Esc>", { noremap = true, silent = true })
-- 使用 <F1> 切換到下一個文檔
vim.api.nvim_set_keymap("n", "<F1>", ":bnext<CR>", { noremap = true, silent = true })
-- 使用 <F1> 切換到前一個文檔
vim.api.nvim_set_keymap("n", "<F1>", ":bprev<CR>", { noremap = true, silent = true })

-- use Ctrl-hjkl to switch between windows
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

-- 使用 <F3> 交換當前視窗和下一個視窗的位置
vim.api.nvim_set_keymap("n", "<F3>", "<C-w>x", { noremap = true, silent = true })

-- Split window
vim.api.nvim_set_keymap("n", "<leader>v", ":vsplit<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>s", ":split<CR>", { noremap = true, silent = true })

-- lsp restart
vim.keymap.set("n", "<leader>R", function()
	vim.cmd("LspRestart")
	require("notify").notify("Lsp Restarted", "info", {
		title = "LSP",
		icon = "",
	})
end)

-- Copilot
vim.g.copilot_assume_mapped = true

-- Clipboard
vim.api.nvim_set_keymap("n", "<leader>y", '"+y<CR>', { noremap = true })
vim.api.nvim_set_keymap("x", "<leader>y", '"+y<CR>', { noremap = true })

-- Celluar Automaton
vim.keymap.set("n", "<leader>wtf", "<cmd>CellularAutomaton make_it_rain<CR>")
vim.keymap.set("n", "<leader>love", "<cmd>CellularAutomaton game_of_life<CR>")

-- Todo comment
vim.keymap.set("n", "<leader>td", "<cmd>TodoTelescope<CR>")

-- Nvim tree
vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true })

-- Fold
-- Key mappings for folding and unfolding
vim.api.nvim_set_keymap("n", "zj", ":foldopen!<CR>", { noremap = true, silent = true }) -- fold open cursor
vim.api.nvim_set_keymap("n", "zk", ":foldclose!<CR>", { noremap = true, silent = true }) -- fold close cursor
-- enable or disable fold
vim.keymap.set("n", "<leader>zm", function()
	if vim.wo.foldenable then
		vim.opt.foldenable = false
		vim.opt.foldlevel = 99
		require("notify").notify("Fold disable", "info", {
			title = "LSP",
			icon = "",
		})
	else
		vim.opt.foldenable = true
		vim.opt.foldlevel = 0
		require("notify").notify("Fold enable", "info", {
			title = "LSP",
			icon = "",
		})
	end
end)

-- Telescope
local default_opts = { noremap = true }
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
vim.api.nvim_set_keymap("n", "<leader>gg", "<cmd>lua require'telescope.builtin'.live_grep()<cr>", default_opts)

-- testing
-- vim.keymap.set("n", "<leader>tt", "<cmd>lua require'neil.scripts'.RunGoTest()<CR>")
vim.keymap.set("n", "<leader>tt", function()
	if vim.bo.filetype == "go" then
		vim.cmd("GoTestFile")
		require("notify").notify("Running GoTestFile", "info", {
			title = "LSP",
			icon = "",
		})
	else
		require("notify").notify("This filetype not supported for test file", "error", {
			title = "Test",
			icon = "",
		})
	end
end)

vim.keymap.set("n", "<leader>tc", function()
	if vim.bo.filetype == "go" then
		vim.cmd("GoTestFunc")
		require("notify").notify("Running GoTestFunc", "info", {
			title = "LSP",
			icon = "",
		})
	else
		require("notify").notify("This filetype not supported for test function", "error", {
			title = "Test",
			icon = "",
		})
	end
end)

vim.keymap.set("n", "<leader>tp", function()
	if vim.bo.filetype == "go" then
		vim.cmd("GoTestPkg")
		require("notify").notify("Running GoTestPkg", "info", {
			title = "LSP",
			icon = "",
		})
	else
		require("notify").notify("This filetype not supported for test pkg", "error", {
			title = "Test",
			icon = "",
		})
	end
end)

vim.keymap.set("n", "<leader>ta", function()
	if vim.bo.filetype == "go" then
		vim.cmd("GoTestSum")
		require("notify").notify("Running GoTestSum", "info", {
			title = "LSP",
			icon = "",
		})
	else
		require("notify").notify("This filetype not supported for test sum", "error", {
			title = "Test",
			icon = "",
		})
	end
end)
