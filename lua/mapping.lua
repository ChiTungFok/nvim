vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = {
    noremap = true,
    silent = true,
    nowait = true
}

vim.keymap.set('n', '<leader>l', ':NvimTreeFindFileToggle<CR>', opt)

local builtin = require('telescope.builtin')
local extensions = require('telescope').extensions
vim.keymap.set('n', '<leader>ff', builtin.fd, opt)
vim.keymap.set('n', '<leader>fg', extensions.live_grep_args.live_grep_args, opt)
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
    cb('n', '<leader>s', function() builtin.lsp_document_symbols({ bufnr = 0 }) end, opt)
    cb('n', '<leader>fm', function() vim.lsp.buf.format() end, opt)
end

-- Trouble
vim.keymap.set("n", "<leader>df", function() require("trouble").toggle() end)
vim.keymap.set("n", "<leader>dw", function() require("trouble").toggle("workspace_diagnostics") end)
vim.keymap.set("n", "<leader>dd", function() require("trouble").toggle("document_diagnostics") end)
vim.keymap.set("n", "<leader>dq", function() require("trouble").toggle("quickfix") end)
vim.keymap.set("n", "<leader>dl", function() require("trouble").toggle("loclist") end)
vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end)

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
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

    ['<Tab>'] = function(fallback)
      if not cmp.select_next_item() then
        if vim.bo.buftype ~= 'prompt' and has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end
    end,

    ['<S-Tab>'] = function(fallback)
      if not cmp.select_prev_item() then
        if vim.bo.buftype ~= 'prompt' and has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end
    end,
}

local actions = require("telescope.actions")
local trouble = require("trouble.providers.telescope")
key_mapper.telescope = {
    i = {
        ["<Up>"] = "move_selection_previous",
        ["<C-k>"] = "move_selection_previous",
        ["<Down>"] = "move_selection_next",
        ["<C-j>"] = "move_selection_next",
        ["<leader>v"] = "file_vsplit",
        ["<leader>x"] = "file_split",
        ["<c-t>"] = trouble.open_with_trouble,
    },
}

return key_mapper
