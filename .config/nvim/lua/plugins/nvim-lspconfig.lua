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
      -- vim.lsp.config("jedi_language_server", { capabilities = capabilities })
      vim.lsp.config("jsonls", { capabilities = capabilities })
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        on_init = function(client)
          if client.workspace_folders then
            local path = client.workspace_folders[1].name
            if
              path ~= vim.fn.stdpath("config")
              and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
            then
              return
            end
          end

          client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
            runtime = {
              -- Tell the language server which version of Lua you're using
              -- (most likely LuaJIT in the case of Neovim)
              version = "LuaJIT",
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                -- Depending on the usage, you might want to add additional paths here.
                -- "${3rd}/luv/library"
                -- "${3rd}/busted/library",
              },
              -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
              -- library = vim.api.nvim_get_runtime_file("", true)
            },
          })
        end,
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
      vim.lsp.config("zuban", { capabilities = capabilities })

      vim.lsp.enable({
        "bashls",
        "cssls",
        "html",
        "hyprls",
        -- "jedi_language_server",
        "jsonls",
        "lua_ls",
        "marksman",
        "texlab",
        "zuban",
      })

      vim.lsp.inline_completion.enable(true)
      vim.keymap.set("i", "<C-CR>", function()
        if not vim.lsp.inline_completion.get() then
          return "<C-CR>"
        end
      end, {
        expr = true,
        replace_keycodes = true,
        desc = "Get the current inline completion",
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          if client:supports_method("textDocument/foldingRange") then
            local win = vim.api.nvim_get_current_win()
            vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
          end

          -- Unmap K
          vim.keymap.del("n", "K", { buffer = args.buf })
          -- vim.keymap.del("n", "KK", { buffer = args.buf })
          vim.keymap.set("n", "KH", vim.lsp.buf.hover, { noremap = true })
        end,
      })
    end,
  },
}
