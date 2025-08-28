return {
  -- nvim-lspconfig
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.lsp.config("bashls", { capabilities = capabilities })
      vim.lsp.config("cssls", { capabilities = capabilities })
      vim.lsp.config("html", { capabilities = capabilities })
      vim.lsp.config("hyprls", {
        capabilities = capabilities,
        root_dir = vim.fn.getcwd(),
      })
      vim.lsp.config("jedi_language_server", { capabilities = capabilities })
      vim.lsp.config("jsonls", { capabilities = capabilities })
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })
      vim.lsp.config("marksman", { capabilities = capabilities })
      vim.lsp.config("texlab", { capabilities = capabilities })

      vim.lsp.enable({
        "bashls",
        "cssls",
        "html",
        "hyprls",
        "jedi_language_server",
        "jsonls",
        "lua_ls",
        "marksman",
        "texlab",
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          -- Unmap K
          vim.keymap.del("n", "K", { buffer = args.buf })
          vim.keymap.set("n", "KH", vim.lsp.buf.hover, { noremap = true })
        end,
      })
    end,
  },
}
