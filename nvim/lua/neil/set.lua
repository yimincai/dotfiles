-- disable netrw at the very start of your init.lua for nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.g.mapleader = " "
vim.g.encoding = "utf-8"

vim.opt.number = true
vim.opt.relativenumber = true

vim.o.termguicolors = true

vim.o.hlsearch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.scrolloff = 20
vim.opt.cursorline = true
vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"

vim.opt.listchars:append("eol:↲")

vim.o.foldmethod = "indent"

vim.opt.clipboard = "unnamedplus"

vim.g.clipboard = {
	name = "myClipboard",
	copy = {
		["+"] = "pbcopy",
		["*"] = "pbcopy",
		["~"] = "xclip -selection clipboard",
		[""] = "xclip -selection clipboard",
	},
	paste = {
		["+"] = "pbpaste",
		["*"] = "pbpaste",
		["~"] = "xclip -selection clipboard -o",
		[""] = "xclip -selection clipboard -o",
	},
	cache_enabled = 0,
}
