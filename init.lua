-- Basic settings first
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.termguicolors = true

-- Keybindings
vim.g.mapleader = " " -- Set spacebar as leader key
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") -- File explorer (space + e to toggle side bar)
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>") -- Space + ff to find files
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>") -- Space + fg to live grep

-- Plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

  -- Cyberpunk theme
  {
    "scottmckendry/cyberdream.nvim",
    config = function()
      require("cyberdream").setup({

        transparent = true,
        italic_comments = true,
        variant = "dark",
        saturation = 0.7,
      })
      vim.cmd("colorscheme cyberdream")
    end,
  },

  -- Lualine status line

  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = { 
          theme = "codedark",
          icons_enabled = true,
        },
      })
    end,
  },

  -- Noice floating elements
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {},
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify", },
    config = function()
      require("noice").setup({
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
      })
    end,
  },

  -- LSP installer
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  -- LSP config helper
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "gopls", "rust_analyzer", "pylsp", "ts_ls", "html", "cssls" }
      })
    end,
  },

  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      -- Languages setup
      lspconfig.gopls.setup({})           -- Go
      lspconfig.rust_analyzer.setup({})   -- Rust
      lspconfig.pylsp.setup({})           -- Python
      lspconfig.ts_ls.setup({})           -- JS/TS
      lspconfig.html.setup({})            -- HTML
      lspconfig.cssls.setup({})           -- CSS

    end,
  },

  -- Autocompletion engine
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
    },
    config = function()
      local cmp = require("cmp")
      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
      cmp.setup({
        mapping = {
          ["<Down>"] = cmp.mapping.select_next_item(),
          ["<Up>"] = cmp.mapping.select_prev_item(),
          ["<Tab>"] = cmp.mapping.confirm({ select = true }),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "buffer" },
        },
      })
    end,
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true, -- Use treesitter for smarter pairing
        ts_config = {
          lua = {'string'}, -- Don't add pairs in lua string treesitter nodes
          javascript = {'template_string'},
        }
      })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {"html", "css", "javascript", "typescript", "go", "rust", "python", "lua"},
        highlight = {
          enable = true,
        },
      })
    end,
  },

  -- Auto closing tags
  {
    "windwp/nvim-ts-autotag",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  -- File Explorer sidebar
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    config = function()
      require("nvim-tree").setup({
        view = { width = 30 },
        renderer = {
          group_empty = true, -- Collapse empty folders
          icons = {
            show = {
              git = true,
            },
          },
        },
      })
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup()
    end,
  },

  -- Quick commenting
  {
    "tpope/vim-commentary", -- Comment current line with 'gcc'
  },

  -- Git integration
  {
    "tpope/vim-fugitive",
  },

  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "-" },
        },
      })
    end,
  },
})
