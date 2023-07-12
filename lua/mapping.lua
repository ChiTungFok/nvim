vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = {
    noremap = true,
    silent = true,
    nowait = true
}

vim.keymap.set('n', '<leader>l', ':NvimTreeFindFileToggle<CR>', opt)

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.fd, opt)
vim.keymap.set('n', '<leader>fg', builtin.live_grep, opt)
vim.keymap.set('n', '<leader>fb', builtin.buffers, opt)
vim.keymap.set('n', '<leader>ft', builtin.tags, opt)
vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find)

for i = 0, 9, 1 do
    vim.keymap.set('n', '<leader>'..tostring(i), tostring(i)..'gt', opt)
end
vim.keymap.set('n', '<leader>tx', ':tabclose<CR>', opt)
vim.keymap.set('n', '<leader>tc', ':tabnew<CR>', opt)
vim.keymap.set('n', '<leader>tn', ':tabnext<CR>', opt)
vim.keymap.set('n', '<leader>tp', ':tabprevious<CR>', opt)
vim.keymap.set('n', '<leader>tf', ':tabfirst<CR>', opt)
vim.keymap.set('n', '<leader>tl', ':tablast<CR>', opt)

-- gitsigns
local gs = require('gitsigns')
vim.keymap.set('n', '<leader>n', gs.next_hunk, opt)
vim.keymap.set('n', '<leader>b', gs.prev_hunk, opt)
vim.keymap.set('n', '<leader>hd', gs.diffthis, opt)

local key_mapper = {}

key_mapper.lsp = function(cb)
    cb('n', 'K', vim.lsp.buf.hover, opt)
    cb('n', 'gd', function() builtin.lsp_definitions({ jump_type = "tab", reuse_win = true }) end, opt)
    cb('n', 'gD', vim.lsp.buf.declaration, opt)
    cb('n', 'gi', function() builtin.lsp_implementations({ jump_type = "tab" }) end, opt)
    cb('n', 'gr', function() builtin.lsp_references({ jump_type = "tab" , reuse_win = true }) end, opt)
    cb('n', '<leader>rn', vim.lsp.buf.rename, opt)
    cb('n', '<leader>ds', function() builtin.diagnostics({ bufnr = 0 }) end, opt)
    cb('n', '<leader>s', function() builtin.lsp_document_symbols({ bufnr = 0 }) end, opt)
    cb('n', '<leader>fm', function() vim.lsp.buf.format() end, opt)
end

local cmp = require('cmp')
key_mapper.cmp = {
    ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
    ['<C-k>'] = cmp.mapping.select_prev_item(select_opts),
    ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
    ['<Down>'] = cmp.mapping.select_next_item(select_opts),
    ['<C-j>'] = cmp.mapping.select_next_item(select_opts),
    ['<C-n>'] = cmp.mapping.select_next_item(select_opts),
    ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
    },
}

key_mapper.telescope = {
    i = {
        ["<Up>"] = "move_selection_previous",
        ["<C-k>"] = "move_selection_previous",
        ["<Down>"] = "move_selection_next",
        ["<C-j>"] = "move_selection_next",
        ["<leader>v"] = "file_vsplit",
        ["<leader>x"] = "file_split",
    },
}

return key_mapper
