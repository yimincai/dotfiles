require("toggleterm").setup{
    size = 20,
    direction = "float",
    open_mapping = [[<c-\>]],
    hide_numbers = true,
    shade_filetypes = {},
    shading_factor = 2,
    start_in_insert = true,
    persist_size = true,
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
            border = "normal",
            backgound = "normal",
        }
    }
}
