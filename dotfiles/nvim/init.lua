-- bootstrap lazy.nvim
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
-- setup lazy.nvim
require("lazy").setup({
	spec = {
		{
			--auto complete
			"saghen/blink.cmp",
			dependencies = "rafamadriz/friendly-snippets",
			version = "1.*",

			---@module 'blink.cmp'
			---@type blink.cmp.Config
			opts = {
				keymap = { preset = "default" },
				cmdline = {
					enable = true,
				},
				appearance = {
					use_nvim_cmp_as_default = true,
					nerd_font_variant = "mono",
				},
				completion = {
					documentation = { auto_show = false },
				},
				signature = { enabled = true },
				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
				},
				fuzzy = { implementation = "prefer_rust_with_warning" },
			},
			opts_extend = { "sources.default" },
		},
		{
			--colorscheme
			"fcancelinha/nordern.nvim",
			branch = "master",
			priority = 1000,
			opts = {
				brighter_comments = true,
				brighter_conditionals = true,
				transparent = false,
			},
			config = function(_, opts)
				require("nordern").setup(opts)
				vim.cmd.colorscheme("nordern")
			end,
		},
		{
			--formatter
			"stevearc/conform.nvim",
			opts = {
				default_format_opts = {
					timeout_ms = 3000,
					async = false,
					quiet = false,
					lsp_format = "fallback",
				},
				format_on_save = {
					timeout_ms = 500,
					lsp_format = "fallback",
				},
				formatters_by_ft = {
					lua = { "stylua" },
					kdl = { "kdlfmt" },
				},
			},
		},
		{ "voldikss/vim-floaterm" },
		{ "imsnif/kdl.vim" },
		{ "neovim/nvim-lspconfig" },
		{
			"mrcjkb/rustaceanvim",
			server = {
				settings = {
					["rust-analyzer"] = {
						diagnostics = {
							disabled = { "inactive-code" },
						},
					},
				},
			},
			version = "^9",
			lazy = false,
		},
		install = {},
		-- automatically check for plugin updates
		checker = { enabled = true },
	},
})

vim.o.number = true
vim.o.mouse = ""
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.relativenumber = true
vim.opt.termguicolors = true

vim.g.mapleader = " "
vim.gnmaplocalleader = "\\"

vim.api.nvim_set_keymap("n", "<leader>rn", "<cmd>set relativenumber!<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<c-t>", ":FloatermToggle<cr>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<c-t>", "<c-\\><c-n>:FloatermToggle<cr>", { noremap = true, silent = true })

local restore_cursor_augroup = vim.api.nvim_create_augroup("restore_cursor_shape_on_exit", { clear = true })

vim.api.nvim_create_autocmd({ "vimleave" }, {
	group = restore_cursor_augroup,
	desc = "restore the cursor shape on exit of neovim",
	command = "set guicursor=a:ver20",
})

local format_group = vim.api.nvim_create_augroup("format_on_write", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
	group = format_group,
	desc = "use formatter on write",
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set("n", "<leader>a", function()
	vim.cmd.RustLsp("codeAction")
end, { silent = true, buffer = bufnr })
vim.opt.termguicolors = true

vim.cmd([[highlight Floaterm guifg=white]])

--vim.cmd([[highlight Normal guibg=#282828]])
--vim.cmd([[highlight MsgArea guibg=#282828]])
--vim.cmd([[highlight BufferLine guibg=#282828]])
