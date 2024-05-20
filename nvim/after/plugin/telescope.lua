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
        file_ignore_patterns = {
            ".DS_Store",
            "mocks/.*",
            "dist/.*",
            "%.git/.*",
            "%.vim/.*",
            "node_modules/.*",
            "%.idea/.*",
            "%.vscode/.*",
            "%.history/.*",
            "package-lock.json",
            "yarn.lock",
        },
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
    pickers = {
        find_files = {
            find_command = { 'rg', '--files', '--hidden', '-g', '!.git' },
        },
    },
})
