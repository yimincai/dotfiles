-- nvim/lua/neil/scripts.lua
local M = {}

function M.RunGoTest()
	-- -- 创建一个新的浮动窗口来显示测试结果
	-- local buf = vim.api.nvim_create_buf(false, true)
	-- local width = vim.api.nvim_get_option("columns")
	-- local height = vim.api.nvim_get_option("lines")
	-- local win_height = math.ceil(height * 0.8)
	-- local win_width = math.ceil(width * 0.8)
	-- local row = math.ceil((height - win_height) / 2)
	-- local col = math.ceil((width - win_width) / 2)
	--
	-- local opts = {
	-- 	style = "minimal",
	-- 	relative = "editor",
	-- 	width = win_width,
	-- 	height = win_height,
	-- 	row = row,
	-- 	col = col,
	-- 	border = "single", -- 设置边框样式为单线
	-- }
	--
	-- local win = vim.api.nvim_open_win(buf, true, opts)
	--
	-- -- 设置浮动窗口的边框高亮样式
	-- vim.api.nvim_win_set_option(win, "winhl", "Normal:Normal") -- 设置边框高亮样式

	-- 获取文件所在目录
	local cwd = vim.fn.expand("%")
	print("cwd: ", cwd)

	-- -- 运行 `go test` 命令
	-- vim.fn.jobstart("go test " .. cwd, {
	-- 	stdout_buffered = true,
	-- 	on_stdout = function(_, data)
	-- 		if data then
	-- 			vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
	-- 		end
	-- 	end,
	-- 	on_stderr = function(_, data)
	-- 		if data then
	-- 			vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
	-- 		end
	-- 	end,
	-- 	on_exit = function()
	-- 		vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "Tests completed" })
	-- 	end,
	-- })
end

return M
