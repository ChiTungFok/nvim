require('nvim-web-devicons').setup()

require('nvim-tree').setup({
    sort_by = 'case_sensitive',
    disable_netrw = true,
    hijack_cursor = true,
    view = {
        width = 36,
        hide_root_folder = false,
        signcolumn = "yes",
    },
    git = {
        enable = true,
    },
    filters = {
        dotfiles = false,
    },
})
