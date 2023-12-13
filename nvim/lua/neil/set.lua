vim.g.mapleader = ' '
vim.g.encoding = 'utf-8'
vim.g.clipboard = 'unnamedplus'
vim.g.hlsearch = true
vim.g.incsearch = true
vim.g.ignorecase = true
vim.g.smartcase = true

vim.o.tabstop = 4 -- always 8 (see :help tabstop)
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.scrolloff = 20
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.number = true
vim.o.wrap = true

vim.o.foldmethod = 'indent'

vim.g.clipboard = {
    name = 'myClipboard',
    copy = {
        ['+'] = 'pbcopy',
        ['*'] = 'pbcopy',
        ['~'] = 'xclip -selection clipboard',
        ['']  = 'xclip -selection clipboard',
    },
    paste = {
        ['+'] = 'pbpaste',
        ['*'] = 'pbpaste',
        ['~'] = 'xclip -selection clipboard -o',
        ['']  = 'xclip -selection clipboard -o',
    },
    cache_enabled = 0,
}
