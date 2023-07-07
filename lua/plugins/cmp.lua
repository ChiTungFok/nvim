local cmp = require ('cmp')
cmp.setup {
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = require('mapping').cmp,
    sources = cmp.config.sources{
        { name = 'nvim_lsp' },
    },
}
