-- [[ Setting options ]]
-- See `:help vim.o`

-- Aliases
local o = vim.opt
local g = vim.g
local wo = vim.wo
local cmd = vim.cmd
local fn = vim.fn

-- Basics
o.history = 100
o.filetype.plugin = "on"
o.filetype.indent = "on"
o.autoread = true
o.syntax = "on"
o.termguicolors = true
o.confirm = true -- confirm on exit w/o save
o.cursorline = true -- highlight current line
o.formatoptions = "jcroqlnt" -- see :help fo-table, default tcqj
o.grepformat = "%f:$l:%c:%m"
o.grepprg = "rg --vimgrep"
o.inccommand = "nosplit"
o.laststatus = 2
o.list = true
o.pumblend = 10 -- popup transparency
o.pumheight = 10 -- max entries in popup menu
o.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" } -- define session
o.showmode = false
o.spelllang = { "en" }

-- Tabs
o.autoindent = true
o.smartindent = true
o.tabstop = 2
o.shiftwidth = 2
o.shiftround = true -- always shift to multiple of shiftwidth
o.softtabstop = 2
o.expandtab = true

-- Linum
o.number = true
o.numberwidth = 4
-- o.relativenumber = true
o.ruler = true

-- Search
o.ignorecase = true
o.smartcase = true
o.hlsearch = true
o.incsearch = true

-- Remove annoying sounds
o.errorbells = false
o.visualbell = false
cmd([[set t_vb =]])
o.tm = 500

-- No backups or swap files
o.backup = false
o.swapfile = false
o.wb = true

-- Undo directory
vim.o.undodir = fn.stdpath("data") .. "/undodir"
o.undofile = true
o.undolevels = 10000

-- Window
o.splitbelow = true
o.splitright = true
o.winminwidth = 5

-- Line wrap
o.wrap = false
o.scrolloff = 10
o.sidescrolloff = 8
o.breakindent = true

-- Mouse mode
o.mouse = "a"

-- Decrease update time
o.updatetime = 250
wo.signcolumn = "yes"

-- Completion
o.completeopt = "menu,menuone,noselect"
o.wildmode = "longest:full,full" -- commandline completion

-- Leader
g.mapleader = " "
g.maplocalleader = " "

-- Clipboard
o.clipboard = "unnamedplus"

-- Markdown style
g.markdown_recommended_style = 0
o.conceallevel = 3 -- hide * markup for bold/italic
