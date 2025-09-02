# autoScheme.nvim

A simple Neovim plugin to automatically switch colorschemes based on the filetype of the opened buffer. This plugin enables a personalized colorscheme experience by applying different colorschemes for different filetypes and falling back to a default colorscheme when no specific match is found.

## Features

- Automatically change colorscheme on buffer enter based on filetype.
- Allows configuring multiple filetype-colorcheme mappings.
- Fallback to a default colorscheme if no mapping is found for the current filetype.
- Gracefully handles errors if a configured colorscheme is not installed.
- Smartly ignores non-file buffers like Neo-tree or terminals to prevent unwanted colorscheme switching.

## Installation

Use your favorite plugin manager. Example with `lazy.nvim`:

    return {
      "BillieLurk/autoScheme.nvim",
      config = function()
        require("autoScheme").setup({
          default = "dogrun", <---- YOUR DEFAULT COLORSCHEME/FALLBACK. 
          schemes = { <---- tables of file types and what colorscheme to use for the filetype
            { filetype = "lua", colorscheme = "kanagawa" },
            { filetype = "javascript", colorscheme = "sonokai" },
            { filetype = "markdown", colorscheme = "carbonfox" },
          },
        })
      end,
    })


## Configuration

`autoScheme.nvim` accepts a table with the following options:

- `default`: The fallback colorscheme name used when no filetype match is found.
- `schemes`: A list of tables specifying filetype to colorscheme mappings. Each item must have:
  - `filetype`: The filetype string to match.
  - `colorscheme`: The colorscheme to apply when that filetype is active.

Example:

    require("autoScheme").setup({
      default = "dogrun",
      schemes = {
        { filetype = "lua", colorscheme = "kanagawa" },
        { filetype = "javascript", colorscheme = "sonokai" },
        { filetype = "markdown", colorscheme = "carbonfox" },
      },
    })

## Usage

Once installed and configured, the plugin automatically detects the filetype on buffer enter and applies the specified colorscheme. It will switch to the default colorscheme if no match is found.

## Notes

- Ensure all specified colorschemes are installed.
- The plugin skips buffers that are not normal files such as Neo-tree, terminals, and quickfix windows to prevent unwanted colorscheme changes.
- Errors with missing colorschemes are reported via a message in the command line.

## License

MIT License

---

Created by BillieLurk — Enhancing your Neovim experience with automatic colorscheme switching.
