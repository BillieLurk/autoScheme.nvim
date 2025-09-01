local M = {}

function M.setup(opts)
	opts = opts or {}
	vim.api.nvim_create_autocmd("BufReadPost", {
		callback = function(args)
			local ft = vim.bo[args.buf].filetype
			vim.notify("Opened " .. (vim.api.nvim_buf_get_name(args.buf) or "??") .. " with ft=" .. ft)
		end,
	})
end

return M
