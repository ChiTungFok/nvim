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
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

require('lspconfig').clangd.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = {
        "/usr/bin/clangd",
        "--background-index",
        "--compile-commands-dir=build",
        "-j=2",
        "--query-driver=/usr/bin/clang++",
        "--clang-tidy",
        "--all-scopes-completion",
        "--completion-style=detailed",
        "--header-insertion=iwyu",
        "--pch-storage=disk",
    },
}
