return {
	{
		"terrortylor/nvim-comment",
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			require("nvim_comment").setup({
				-- Linters prefer comment and line to have a space in between markers
				marker_padding = true,
				-- should comment out empty or whitespace only lines
				comment_empty = true,
				-- trim empty comment whitespace
				comment_empty_trim_whitespace = true,
				-- Should key mappings be created
				create_mappings = true,
				-- Normal mode mapping left hand side
				line_mapping = "gcc",
				-- Visual/Operator mapping left hand side
				operator_mapping = "gc",
				-- text object mapping, comment chunk,,
				comment_chunk_text_object = "ic",
				-- Hook function to call before commenting takes place
				hook = function()
					local filetype = vim.api.nvim_buf_get_option(0, "filetype")
					if filetype == "templ" or filetype == "vue" then
						vim.api.nvim_buf_set_option(0, "commentstring", "<!-- %s -->")
					end

					-- if filetype == "vue" then
					-- 	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
					-- 	for _, line in ipairs(lines) do
					-- 		if line:match("^%s*<template*") then
					-- 			vim.api.nvim_buf_set_option(0, "commentstring", "<!-- %s -->")
					-- 		elseif line:match("^%s*<script*") then
					-- 			vim.api.nvim_buf_set_option(0, "commentstring", "// %s")
					-- 		elseif line:match("^%s*<style*") then
					-- 			vim.api.nvim_buf_set_option(0, "commentstring", "/* %s */")
					-- 		end
					-- 	end
					-- end
				end,
			})
		end,
	},
}
