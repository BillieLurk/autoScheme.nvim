if vim.g.loaded_autoScheme then
	return
end
vim.g.loaded_autoScheme = true

require("autoScheme").setup()
