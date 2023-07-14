local navbuddy = require("nvim-navbuddy")

local on_attach = function(client, bufnr)
    local function set_key_mapper(mode, l, r, opts)
        -- vim.api.nvim_buf_set_keymap(bufnr, ...)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
    end
    require('mapping').lsp(set_key_mapper)
    navbuddy.attach(client, bufnr)

    if client.name == 'gopls' and not client.server_capabilities.semanticTokensProvider then
        local semantic = client.config.capabilities.textDocument.semanticTokens
        client.server_capabilities.semanticTokensProvider = {
            full = true,
            legend = {tokenModifiers = semantic.tokenModifiers, tokenTypes = semantic.tokenTypes},
            range = true,
        }
    end
end

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  callback = function()
      vim.lsp.buf.format()
      vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
  end
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

require('lspconfig').gopls.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = {"/root/go/bin/gopls", "serve"},
    settings = {
      gopls = {
          gofumpt = true,
          semanticTokens = true,
          analyses = {
              unusedparams = true,
          },
          staticcheck = true,
      },
  },
}
