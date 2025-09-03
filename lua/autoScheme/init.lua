local M = {}
M.config = {
	schemes = {},
	default = "",
	once_per_buffer = false, -- no longer relevant, but kept for compatibility
	defer_ms = 5,
	refresh_lualine = true,
}

local function refresh_lualine()
	local ok, lualine = pcall(require, "lualine")
	if ok and type(lualine.refresh) == "function" then
		lualine.refresh({
			place = { "statusline", "tabline", "winbar" },
			trigger = "colorscheme",
			reload_theme = true,
		})
	end
end

local function apply_colorscheme(name, cfg)
	if not name or name == "" or vim.g.colors_name == name then
		return
	end
	local ok = pcall(function()
		vim.cmd.colorscheme(name)
	end)
	if not ok then
		vim.schedule(function()
			vim.notify(("autoScheme: cannot find colorscheme '%s'"):format(name), vim.log.levels.WARN)
		end)
		return
	end
	if cfg.refresh_lualine then
		vim.schedule(refresh_lualine)
		vim.schedule(function()
			pcall(vim.cmd, "silent! redrawstatus")
		end)
	end
end

local function resolve_scheme(ft)
	for _, s in ipairs(M.config.schemes or {}) do
		if s.filetype == ft then
			return s.colorscheme
		end
	end
	return M.config.default
end

function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})
	vim.api.nvim_create_autocmd({ "BufEnter" }, {
		desc = "autoScheme: switch colorscheme per buffer/filetype on buffer enter",
		callback = function(args)
			local bt = vim.bo[args.buf].buftype
			if bt ~= "" then
				return
			end
			local ft = vim.bo[args.buf].filetype
			if not ft or ft == "" then
				return
			end
			local target = resolve_scheme(ft)
			if not target or target == "" or target == vim.g.colors_name then
				return
			end
			-- defer a bit to avoid race with other events (like lualine/lsp)
			if M.config.defer_ms and M.config.defer_ms > 0 then
				vim.defer_fn(function()
					apply_colorscheme(target, M.config)
				end, M.config.defer_ms)
			else
				vim.schedule(function()
					apply_colorscheme(target, M.config)
				end)
			end
		end,
	})
end

return M
