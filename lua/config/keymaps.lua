-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<C-e>", ":Neotree<CR>", {})

-- TMUX <-> VIM NAVIGATION
local tmux = require("tmux")
vim.keymap.set("n", "<C-k>", tmux.move_top, {})
vim.keymap.set("n", "<C-j>", tmux.move_bottom, {})
vim.keymap.set("n", "<C-h>", tmux.move_left, {})
vim.keymap.set("n", "<C-l>", tmux.move_right, {})

-- TOGGLETERM
local toggleterm = require("toggleterm")

-- redefine function that sends lines to terminal

local lazy = require("toggleterm.lazy")
local utils = lazy.require("toggleterm.utils")

local function custom_send_lines_to_terminal(selection_type, trim_spaces, cmd_data)
  local id = tonumber(cmd_data.args) or 1
  trim_spaces = trim_spaces == nil or trim_spaces

  vim.validate({
    selection_type = { selection_type, "string", true },
    trim_spaces = { trim_spaces, "boolean", true },
    terminal_id = { id, "number", true },
  })

  local current_window = vim.api.nvim_get_current_win() -- save current window

  local lines = {}
  -- Beginning of the selection: line number, column number
  local start_line, start_col
  if selection_type == "single_line" then
    start_line, start_col = unpack(vim.api.nvim_win_get_cursor(0))
    table.insert(lines, vim.fn.getline(start_line))
  elseif selection_type == "visual_lines" then
    local res = utils.get_line_selection("visual")
    start_line, start_col = unpack(res.start_pos)
    lines = res.selected_lines
  elseif selection_type == "visual_selection" then
    local res = utils.get_line_selection("visual")
    start_line, start_col = unpack(res.start_pos)
    lines = utils.get_visual_selection(res)
  end

  if not lines or not next(lines) then
    return
  end

  local startingSpaces = nil
  for _, line in ipairs(lines) do
    local l = trim_spaces and line:gsub("^%s+", ""):gsub("%s+$", "") or line
    -- FIX FOR PYTHON INDENT TO WORK CORRECTLY
    if not string.match(l, "^%s*$") then
      if startingSpaces == nil then
        _, startingSpaces = string.find(l, "^ *")
      end
      local l_norm = string.gsub(l, " ", "", startingSpaces)
      toggleterm.exec(l_norm, id)
    end
    -- print(l)
  end
  toggleterm.exec("", id)

  -- Jump back with the cursor where we were at the beginning of the selection
  vim.api.nvim_set_current_win(current_window)
  vim.api.nvim_win_set_cursor(current_window, { start_line, start_col })
end

vim.api.nvim_create_user_command("ToggleTermSendVisualSelectionCustom", function(args)
  custom_send_lines_to_terminal("visual_selection", false, args)
end, { range = true, nargs = "?" })

require("which-key").register({
  ["<leader>t"] = { name = "terminal", _ = "which_key_ignore" },
})

vim.keymap.set(
  "n",
  "<leader>tp",
  ":TermExec direction=vertical size=120 cmd='${VIRTUAL_ENV:+$VIRTUAL_ENV/bin/}python'<CR>",
  { desc = "Open Python terminal" }
)
vim.keymap.set(
  "n",
  "<leader>ti",
  ":TermExec direction=vertical size=120 cmd='${VIRTUAL_ENV:+$VIRTUAL_ENV/bin/}ipython --TerminalInteractiveShell.autoindent=False'<CR>",
  { desc = "Open IPython terminal" }
)
vim.keymap.set("n", "<leader>tv", ":ToggleTerm direction=vertical size=120<CR>", { desc = "Open vertical terminal" })
vim.keymap.set("n", "<leader>ts", ":ToggleTerm direction=horizontal size=40<CR>", { desc = "Open horizontal terminal" })
vim.keymap.set(
  "n",
  "<leader>tf",
  ":w<CR>:9TermExec direction=vertical size=120 cmd='${VIRTUAL_ENV:+$VIRTUAL_ENV/bin/}python %'<CR>",
  { desc = "Save and run file in python" }
)
vim.keymap.set("n", "<leader>tt", ":ToggleTermSendCurrentLine<CR>j", { desc = "Send line to terminal" })
vim.keymap.set("v", "<leader>tt", ":ToggleTermSendVisualSelectionCustom<CR>'>", { desc = "Send selection to terminal" })
vim.keymap.set("n", "<leader>r", ":ToggleTermSendCurrentLine<CR>j", { desc = "Send line to terminal" })
vim.keymap.set("v", "<leader>r", ":ToggleTermSendVisualSelectionCustom<CR>'>", { desc = "Send selection to terminal" })
vim.keymap.set("n", "<leader>tq", ":TermSelect<CR>1<CR>i<C-d><C-d>", { desc = "Quit terminal" })
