local M = {}

M.config = {
	schemes = {},
	default = "",
}

function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})
	opts = opts or {}
	vim.api.nvim_create_autocmd("BufEnter", {
		callback = function(args)
			local buftype = vim.bo[args.buf].buftype
			local ft = vim.bo[args.buf].filetype

			if buftype ~= "" then
				return
			end

			if ft == nil or ft == "" then
				return
			end

			local matched = false
			for _, scheme in pairs(M.config.schemes) do
				if ft == scheme.filetype then
					local ok, _ = pcall(vim.cmd, "colorscheme " .. scheme.colorscheme)
					if not ok then
						print("Error: Cannot find color scheme '" .. scheme.colorscheme .. "'")
					end
					matched = true
					break
				end
			end

			if not matched then
				local ok, _ = pcall(vim.cmd, "colorscheme " .. M.config.default)
				if not ok then
					print("Error: Cannot find default color scheme '" .. M.config.default .. "'")
				end
			end
		end,
	})
end

return M
