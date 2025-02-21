return
	{ "nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",  -- Use the build command to update Treesitter parsers                                                                                                                                                                                                                       
		config = function()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = {
					"c", "lua", "vim", "vimdoc", "query", "elixir", "javascript", "html", "python", "go", "hyprlang", "bash", "fish"
				},
				sync_install = false,  -- Do not install parsers synchronously
				highlight = { enable = true },  -- Enable Treesitter highlighting
				indent = { enable = true },  -- Enable Treesitter-based indentation
			})


		end
	}
