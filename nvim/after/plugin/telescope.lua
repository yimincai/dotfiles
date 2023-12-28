require("telescope").setup({
    defaults = {
        prompt_prefix = "🔭 ",
        selection_caret = " ",
        sorting_strategy = "descending",
        layout_strategy = "horizontal",
        layout_config = {
            horizontal = {
                mirror = false,
                preview_width = 0.5,
            },
            vertical = {
                mirror = false,
            },
        },
        file_ignore_patterns = { "node_modules", ".git", ".cache", ".DS_Store", ".vscode", ".idea", "mocks" },
        mappings = {
            i = {
                ["<C-k>"] = "move_selection_previous",
                ["<C-j>"] = "move_selection_next",
                ["<C-s>"] = "select_vertical",
                ["<C-a>"] = "select_tab",
            },
            n = {
                ["<C-k>"] = "move_selection_previous",
                ["<C-j>"] = "move_selection_next",
                ["<C-s>"] = "select_vertical",
                ["<C-a>"] = "select_tab",
            }
        },
    },
})

local map = vim.api.nvim_set_keymap
local default_opts = { noremap = true }

map('n', '<leader>sf',
    "<cmd>lua require'telescope.builtin'.find_files()<cr>",
    default_opts)
map('n', '<leader>sa', "<cmd>lua require'telescope.builtin'.buffers({ show_all_buffers = true })<cr>", default_opts)
map('n', '<leader>sd', "<cmd>lua require'telescope.builtin'.git_status()<cr>", default_opts)
map('n', '<leader>td', ":TodoTelescope<cr>", default_opts)
-- map('n', '<leader>/', ":silent grep ", default_opts)
map('n', '<leader>g', "<cmd>lua require'telescope.builtin'.live_grep()<cr>", default_opts)
