vim.o.number = true
vim.o.mouse = ""
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.relativenumber = true

vim.g.mapleader = " "

vim.api.nvim_set_keymap( "n", "<Leader>rn", "<Cmd>set relativenumber!<CR>", { noremap = true, silent = true })

local restore_cursor_augroup = vim.api.nvim_create_augroup( "restore_cursor_shape_on_exit", { clear = true })

vim.api.nvim_create_autocmd({"kimLeave"},{
group = restore_cursor_augroup,
    desc = "restore the cursor shape on exit of neovim",
    command = "set guicursor=a:ver20",
})

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },

			{ "\nPress any key to exit..." },
		}, true, {})
		
		vim.fn.getchar()
		os.exit(1)
	end
end

vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        {
          "saghen/blink.cmp",
          -- optional: provides snippets for the snippet source
          dependencies = 'rafamadriz/friendly-snippets',

          -- use a release tag to download pre-built binaries
          version = '*',
          -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
          -- build = 'cargo build --release',
          -- If you use nix, you can build from source using latest nightly rust with:
          -- build = 'nix run .#build-plugin',

          ---@module 'blink.cmp'
          ---@type blink.cmp.Config
          opts = {
            -- 'default' for mappings similar to built-in completion
            -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
            -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
            -- See the full "keymap" documentation for information on defining your own keymap.
            keymap = { preset = 'default' },

            appearance = {

              -- Sets the fallback highlight groups to nvim-cmp's highlight groups
              -- Useful for when your theme doesn't support blink.cmp
              -- Will be removed in a future release
              use_nvim_cmp_as_default = true,
              -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
              -- Adjusts spacing to ensure icons are aligned
              nerd_font_variant = 'mono'

            },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
              default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
          },
          opts_extend = { "sources.default" }
        },
        {
            'neovim/nvim-lspconfig',
            dependencies = { 'saghen/blink.cmp' },
            opts = {
                servers = {
                    lua_ls = {}
                }
            },
            config = function(_, opts)
                local lspconfig = require('lspconfig')
                for server, config in pairs(opts.servers) do
                    -- passing config.capabilities to blink.cmp merges with the capabilities in your
                    -- `opts[server].capabilities, if you've defined it
                    config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
                    lspconfig[server].setup(config)
                end
            end,
        },
        {
            "fcancelinha/nordern.nvim",
            branch = "master",
            priority = 1000,
            opts = {
                brighter_comments = true,
                brighter_conditionals = true,
                transparent = false,
            },
            config = function( _, opts )
                require( "nordern" ).setup( opts )
                vim.cmd.colorscheme( "nordern" )
            end,
        },
        { 'stevearc/conform.nvim', opts = {} },

        -- Configure any other settings here. See the documentation for more details.
        -- colorscheme that will be used when installing plugins.
        install = { },
        -- automatically check for plugin updates
        checker = { enabled = true },
    }
})

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    python = { "isort", "black" },
    -- You can customize some of the format options for the filetype (:help conform.format)
    rust = { "rustfmt", lsp_format = "fallback" },
    -- Conform will run the first available formatter
    javascript = { "prettierd", "prettier", stop_after_first = true },
  },
})

vim.opt.termguicolors = true
vim.cmd [[highlight Normal guibg=#282828]]
vim.cmd [[highlight MsgArea guibg=#282828]]
vim.cmd [[highlight BufferLine guibg=#282828]]
