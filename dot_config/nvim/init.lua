-- Basics
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

-- Key mappings
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

-- Autocommands
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

-- Theme
vim.cmd.colorscheme("catppuccin")
--vim.cmd.colorscheme("retrobox")

-- Statusline
-- mode -> { label, highlight group whose fg color is used for that mode }
local modes = {
  n = { "NORMAL", "DiagnosticInfo" }, i = { "INSERT", "DiagnosticOk" }, t = { "TERMINAL", "DiagnosticOk" },
  v = { "VISUAL", "DiagnosticWarn" }, V = { "V-LINE", "DiagnosticWarn" }, ["\22"] = { "V-BLOCK", "DiagnosticWarn" },
  s = { "SELECT", "DiagnosticWarn" }, S = { "S-LINE", "DiagnosticWarn" }, ["\19"] = { "S-BLOCK", "DiagnosticWarn" },
  R = { "REPLACE", "DiagnosticError" }, c = { "COMMAND", "DiagnosticHint" },
}

local function get(name, attr)
  local h = vim.api.nvim_get_hl(0, { name = name, link = false })
  if h.reverse then attr = attr == "fg" and "bg" or "fg" end
  return h[attr]
end

local function set_colors()
  local set = vim.api.nvim_set_hl
  local base = get("Normal", "bg") or (vim.o.background == "dark" and 0x000000 or 0xffffff)
  local c_fg, c_bg = get("StatusLine", "fg"), get("StatusLine", "bg")
  local b_bg = get("CursorLine", "bg") or base
  set(0, "StatusLine", { fg = c_fg, bg = c_bg }) -- flatten reverse/bold so our groups don't inherit them
  set(0, "StlCB", { fg = b_bg, bg = c_bg })
  for _, m in pairs(modes) do
    local col = get(m[2], "fg") or c_fg
    set(0, "StlA" .. m[2], { fg = base, bg = col, bold = true })
    set(0, "StlB" .. m[2], { fg = col, bg = b_bg })
    set(0, "StlAC" .. m[2], { fg = col, bg = c_bg })
  end
end

local file = " %t%( %m%r%)"

function _G.Statusline()
  local win = vim.g.statusline_winid
  if win ~= vim.api.nvim_get_current_win() then return file .. "%=%3l:%-2v " end -- inactive window

  local m = modes[vim.fn.mode():sub(1, 1)] or modes.n
  local bo = vim.bo[vim.api.nvim_win_get_buf(win)]
  local info = vim.tbl_filter(function(s) return s ~= "" end,
    { bo.fenc ~= "" and bo.fenc or vim.o.enc, bo.fileformat, bo.filetype })
  local a, b = "%#StlA" .. m[2] .. "#", "%#StlB" .. m[2] .. "#"

  return table.concat({
    a, " ", m[1], " %#StlAC", m[2], "#\u{e0b0}%#StatusLine#", file, "%=",
    table.concat(info, " \u{e0b3} "), " %#StlCB#\u{e0b2}",
    b, " %3P \u{e0b2}", a, " %3l:%-2v ",
  })
end

vim.o.statusline = "%!v:lua.Statusline()"
vim.o.showmode = false
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_colors })
vim.api.nvim_create_autocmd("ModeChanged", { command = "redrawstatus" })
set_colors()
