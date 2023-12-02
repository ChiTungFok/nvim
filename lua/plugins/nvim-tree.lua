require('nvim-web-devicons').setup()

require('nvim-tree').setup({
    sort_by = 'case_sensitive',
    disable_netrw = true,
    hijack_cursor = true,
    view = {
        width = 36,
        signcolumn = "yes",
    },
    renderer = {
        group_empty = true,
        root_folder_label = true,
    },
    git = {
        enable = true,
    },
    filters = {
        dotfiles = false,
    },
})
