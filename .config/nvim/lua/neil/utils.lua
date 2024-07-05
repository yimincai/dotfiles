local M = {}

--- Generates the LSP client capabilities
--- @return table
-- function M.default_capabilities()
-- Client capabilities
--	local capabilities = vim.lsp.protocol.make_client_capabilities()

--- Setup capabilities to support utf-16, since copilot.lua only works with utf-16
--- this is a workaround to the limitations of copilot language server
--	capabilities = vim.tbl_deep_extend("force", capabilities, {
-- 		offsetEncoding = "utf-16",
-- general = {
-- 			positionEncodings = { "utf-16" },
--		},
-- 	})

-- 	return capabilities
-- end

return M
