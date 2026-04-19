-- ########## Basics
vim.opt.history = 100
vim.opt.filetype.plugin = "on"
vim.opt.filetype.indent = "on"
vim.opt.autoread = true
vim.opt.syntax = "on"
vim.opt.termguicolors = true
vim.opt.confirm = true -- confirm on exit w/o save
vim.opt.cursorline = true -- highlight current line
vim.opt.formatoptions = "jcroqlnt" -- see :help fo-table, default tcqj
vim.opt.grepformat = "%f:$l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.inccommand = "nosplit"
vim.opt.list = true
vim.opt.pumblend = 10 -- popup transparency
vim.opt.pumheight = 10 -- max entries in popup menu
vim.opt.showmode = false
vim.opt.spelllang = "en_us"

-- Tabs
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true -- always shift to multiple of shiftwidth
vim.opt.softtabstop = 2
vim.opt.expandtab = true

-- Linum
vim.opt.number = true
vim.opt.numberwidth = 4
-- o.relativenumber = true
vim.opt.ruler = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Remove annoying sounds
vim.opt.errorbells = false
vim.opt.visualbell = false
vim.cmd([[set t_vb =]])
vim.opt.tm = 500

-- No backups or swap files
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.wb = true

-- Undo directory
vim.o.undodir = vim.fn.stdpath("data") .. "/undodir"
vim.opt.undofile = true
vim.opt.undolevels = 10000

-- Window
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.winminwidth = 5

-- Line wrap
vim.opt.wrap = false
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8
vim.opt.breakindent = true

-- Mouse mode
vim.opt.mouse = "a"

-- Decrease update time
vim.opt.updatetime = 250
vim.wo.signcolumn = "yes"

-- Completion
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.wildmode = "longest:full,full" -- commandline completion

-- Clipboard
vim.opt.clipboard = "unnamedplus"

-- Markdown style
vim.g.markdown_recommended_style = 0
vim.opt.conceallevel = 3 -- hide * markup for bold/italic

-- ########## Key mappings
-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Clear search highlights on pressing Esc
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1 })
end)
vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1 })
end)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Better subwindow navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- ########## Autocommands
local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = augroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  desc = "Auto resize splits when the terminal's window is resized",
  group = augroup,
  command = "wincmd =",
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "No auto continue comments on new line",
  group = augroup,
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- ########## Theme
vim.cmd.colorscheme("default")

-- Statusline
local mode_labels = {
  n       = "",
  i       = "-- INSERT --  ",
  v       = "-! VISUAL !-  ",
  V       = "-- V-LINE --  ",
  ["\22"] = "!! V-BLOCK !! ",
  c       = "CMD  ",
  R       = "REPLACE  ",
  t       = "TERM  ",
}

function _G.statusline_render()
  local label = mode_labels[vim.fn.mode()] or ""

  local name  = vim.fn.expand("%:t")
  if name == "" then name = "[no name]" end
  local flags = (vim.bo.modified and " [+]" or "") .. (not vim.bo.modifiable and " [-]" or "")

  local errors   = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
  local ft       = vim.bo.filetype ~= "" and (vim.bo.filetype .. "  ") or ""

  vim.api.nvim_set_hl(0, "MyStatusLine", { bold = true })

  return table.concat({
    "%#MyStatusLine#",
    "  ", label, name, flags, " ",
    "%=",
    errors   > 0 and ("E:" .. errors .. " ")  or "",
    warnings > 0 and ("W:" .. warnings .. " ") or "",
    ft, "%l:%c  %p%%  ",
  })
end

vim.o.statusline = "%{%v:lua.statusline_render()%}"
vim.o.laststatus = 2
