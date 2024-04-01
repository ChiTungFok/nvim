local cmp = require ('cmp')
local compare = require('cmp.config.compare')
cmp.setup {
   snippet = {
      expand = function(args)
      require('luasnip').lsp_expand(args.body)
      end,
   },
   mapping = require('mapping').cmp,
   sources = cmp.config.sources{
      { name = "nvim_lsp", priority = 8 },
   },
   sorting = {
      priority_weight = 2,
      comparators = {
         compare.score,
         compare.locality,
         compare.recently_used,
         compare.offset,
         compare.order,
         compare.exact,
         compare.kind,
         compare.sort_text,
         compare.length,
      },
   },
}
