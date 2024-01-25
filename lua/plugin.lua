local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system(
        {
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath
        }
    )
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
    {
        "kyazdani42/nvim-tree.lua",
        dependencies = {"kyazdani42/nvim-web-devicons", "nvim-web-devicons"}
    },
    "windwp/nvim-autopairs",
    {"lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {}},
    "numToStr/Comment.nvim",
    {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
            "neovim/nvim-lspconfig",
            "SmiteshP/nvim-navic",
            "MunifTanjim/nui.nvim",
            "numToStr/Comment.nvim", -- Optional
            "nvim-telescope/telescope.nvim" -- Optional
        }
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            {"nvim-lua/plenary.nvim"},
            {"nvim-telescope/telescope-live-grep-args.nvim"},
            {"nvim-telescope/telescope-fzf-native.nvim", build = "make"}
        },
        config = function(plugin)
            require("telescope").load_extension("fzf")
            require("telescope").load_extension("live_grep_args")
        end
    },
    {"sindrets/diffview.nvim", dependencies = "nvim-lua/plenary.nvim"},
    "lewis6991/gitsigns.nvim",
    {"catppuccin/nvim", name = "catppuccin"},
    "folke/tokyonight.nvim",
    "AstroNvim/astrotheme",
    {
        "olimorris/onedarkpro.nvim",
        priority = 1000 -- Ensure it loads first
    },
    "neovim/nvim-lspconfig",
    "hrsh7th/nvim-cmp", -- Autocompletion plugin
    "hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp
    "saadparwaiz1/cmp_luasnip", -- Snippets source for nvim-cmp
    "L3MON4D3/LuaSnip", -- Snippets plugin
    {"folke/trouble.nvim", dependencies = {"nvim-tree/nvim-web-devicons"}},
    {
        "simrat39/rust-tools.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-lua/plenary.nvim",
            "mfussenegger/nvim-dap"
        }
    },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = {"kevinhwang91/promise-async"},
        lazy = true,
        cmd = {"UfoDisable", "UfoEnable"},
        config = function()
            vim.o.foldcolumn = "1" -- '0' is not bad
            vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true

            vim.cmd([[highlight AdCustomFold guifg=#bf8040]])
            local handler = function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                local suffix = ("  %d "):format(endLnum - lnum)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0

                for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                        table.insert(newVirtText, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        local hlGroup = chunk[2]
                        table.insert(newVirtText, {chunkText, hlGroup})
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        -- str width returned from truncate() may less than 2nd argument, need padding
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end

                -- Second line
                local lines = vim.api.nvim_buf_get_lines(0, lnum, lnum + 1, false)
                local secondLine = nil
                if #lines == 1 then
                    secondLine = lines[1]
                elseif #lines > 1 then
                    secondLine = lines[2]
                end
                if secondLine ~= nil then
                    table.insert(newVirtText, {secondLine, "AdCustomFold"})
                end

                table.insert(newVirtText, {suffix, "MoreMsg"})

                return newVirtText
            end

            require("ufo").setup(
                {
                    provider_selector = function(bufnr, filetype, buftype)
                        return {"lsp", "indent"}
                    end,
                    fold_virt_text_handler = handler
                }
            )
        end
    }
}

return require("lazy").setup(plugins)
