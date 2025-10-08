return {
  -- install mason.nvim and mason-lspconfig.nvim for managing LSP binaries
  {
    "williamboman/mason.nvim",
    opts = {},
    config = true
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = { "gopls", "pylsp" }, -- auto-install Go and Python LSPs
      automatic_installation = true
    },
    config = true
  },
  {
    "neovim/nvim-lspconfig",
    -- config = true
  }
}
