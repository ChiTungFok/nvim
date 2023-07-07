require('telescope').setup{
    defaults = {
        initial_mode = "insert",
        mappings = require('mapping').telescope
    },
}

require('telescope').load_extension('fzf')
