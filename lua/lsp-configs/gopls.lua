local navbuddy = require("nvim-navbuddy")

local on_attach = function(client, bufnr)
    local function set_key_mapper(mode, l, r, opts)
        -- vim.api.nvim_buf_set_keymap(bufnr, ...)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
    end
    require("mapping").lsp(set_key_mapper)
    navbuddy.attach(client, bufnr)

    if client.name == "gopls" and not client.server_capabilities.semanticTokensProvider then
        local semantic = client.config.capabilities.textDocument.semanticTokens
        client.server_capabilities.semanticTokensProvider = {
            full = true,
            legend = {tokenModifiers = semantic.tokenModifiers, tokenTypes = semantic.tokenTypes},
            range = true
        }
    end
end

vim.api.nvim_create_autocmd(
    "BufWritePre",
    {
        pattern = "*.go",
        callback = function()
            local params = vim.lsp.util.make_range_params()
            params.context = {only = {"source.organizeImports"}}
            -- buf_request_sync defaults to a 1000ms timeout. Depending on your
            -- machine and codebase, you may want longer. Add an additional
            -- argument after params if you find that you have to write the file
            -- twice for changes to be saved.
            -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
            local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 800)
            for cid, res in pairs(result or {}) do
                for _, r in pairs(res.result or {}) do
                    if r.edit then
                        local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                        vim.lsp.util.apply_workspace_edit(r.edit, enc)
                    end
                end
            end
            vim.lsp.buf.format({async = false})
            -- vim.lsp.buf.format()
            -- vim.lsp.buf.code_action({context = {only = {"source.organizeImports"}}, apply = true})
        end
    }
)

local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}

require("lspconfig").gopls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = {"/root/go/bin/gopls", "serve"},
    settings = {
        gopls = {
            gofumpt = true,
            semanticTokens = true,
            analyses = {
                unusedparams = true
            }
        }
    }
}
