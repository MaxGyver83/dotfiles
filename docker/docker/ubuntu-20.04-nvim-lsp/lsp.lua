-- vim.cmd("set packpath+=~/.vim/pack")
vim.cmd("set completeopt=menu,menuone,noselect")

local cmp = require'cmp'
cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    -- { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Mappings.
    local opts = { noremap = true, silent = true, buffer = bufnr }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    -- (Use `":lua func()<CR>"` instead of simply `func` because otherwise
    --  the name of func is hidden in `:map` and `:Maps`.)
    vim.keymap.set('n', '<leader>lg', ":lua vim.lsp.buf.definition()<CR>", opts)
    vim.keymap.set('n', '<leader>lD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', '<leader>lt', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>li', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>ld', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>lh', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>ln', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<leader>lc', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>le', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '<leader>lj', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', '<leader>lk', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<leader>lq', vim.diagnostic.setloclist, opts)
    vim.keymap.set('n', '<leader>lf', vim.lsp.buf.formatting, opts)
    -- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    --     vim.lsp.diagnostic.on_publish_diagnostics, {
    --         virtual_text = false
    --     }
    -- )
end

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pyright', 'clangd' }
for _, lsp in pairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities
  }
end

local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        -- null_ls.builtins.code_actions.shellcheck,
        -- null_ls.builtins.diagnostics.ccls,
        -- null_ls.builtins.diagnostics.gccdiag,
        null_ls.builtins.diagnostics.pylint,
        -- null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.diagnostics.yamllint,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,
    },
})
-- Apply formatting with `:lua vim.lsp.buf.formatting()` (or <space>lf)


vim.g.diagnostics_visible = true
function _G.toggle_diagnostics()
  if vim.g.diagnostics_visible then
    vim.g.diagnostics_visible = false
    vim.diagnostic.disable()
  else
    vim.g.diagnostics_visible = true
    vim.diagnostic.enable()
  end
end
vim.keymap.set('n', '<leader>ll', toggle_diagnostics)

vim.diagnostic.config({virtual_text = false})
vim.g.inline_diagnostics_visible = false
function _G.toggle_inline_diagnostics()
  if vim.g.inline_diagnostics_visible then
    vim.g.inline_diagnostics_visible = false
    vim.diagnostic.config({virtual_text = false})
  else
    vim.g.inline_diagnostics_visible = true
    vim.diagnostic.config({virtual_text = true})
  end
end
vim.keymap.set('n', '<leader>l ', toggle_inline_diagnostics)
