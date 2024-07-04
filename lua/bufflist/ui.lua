local api = vim.api
local buffers = require("bufflist.buffers")

local m = {
  buf = -1,
  win = -1,
  buffers = {},
  entries = {}
}

function m.open_window()
  m.buf = api.nvim_create_buf(false, true)
  local border_buf = api.nvim_create_buf(false, true)

  api.nvim_buf_set_option(m.buf, 'bufhidden', 'wipe')      --api.nvim_set_option_value( 'bufhidden', 'value', {buf = buf})
  api.nvim_buf_set_option(m.buf, 'filetype', 'bufferlist') --api.nvim_set_option_value( 'filetype', 'bufferlist', {buf = buf})

  local width = api.nvim_get_option("columns")             --api.nvim_get_option_value("column")
  local height = api.nvim_get_option("lines")              --api.nvim_get_option_value("column")


  local win_height = math.ceil(height * 0.5 - 4)
  local win_width = math.ceil(width * 0.4)
  local row = math.ceil((height - win_height) / 2 - 1)
  local col = math.ceil((width - win_width) / 2)

  local border_opts = {
    style = 'minimal',
    relative = 'editor',
    width = win_width + 2,
    height = win_height + 2,
    row = row - 1,
    col = col - 1
  }

  local opts = {
    style = 'minimal',
    relative = 'editor',
    width = win_width,
    height = win_height,
    row = row,
    col = col
  }

  local border_title = ' Buffer List '
  local border_lines = { '╭' .. border_title .. string.rep('─', win_width - string.len(border_title)) .. '╮' }
  local middle_line = '│' .. string.rep(' ', win_width) .. '│'
  for _ = 1, win_height do
    table.insert(border_lines, middle_line)
  end
  table.insert(border_lines, '╰' .. string.rep('─', win_width) .. '╯')
  api.nvim_buf_set_lines(border_buf, 0, -1, false, border_lines)

  api.nvim_open_win(border_buf, true, border_opts)
  m.win = api.nvim_open_win(m.buf, true, opts)
  api.nvim_command('au BufWipeout <buffer> exe "silent bwipeout! "' .. border_buf)

  api.nvim_win_set_option(m.win, 'cursorline', true)
end

function m.update_view()
  m.buffers, m.entries = buffers.parse_buffs()
  local result = {}

  api.nvim_buf_set_option(m.buf, 'modifiable', true)

  for _, entry in ipairs(m.entries) do
    table.insert(result, entry.bufnr .. ':' .. entry.winid .. entry.hidden .. entry.name)
  end

  api.nvim_buf_set_lines(m.buf, 0, -1, false, result)
  api.nvim_buf_set_option(m.buf, 'modifiable', false)
end

function m.close_window()
  api.nvim_win_close(m.win, true)
end

function m.close_buffer()
  local cursor_row = api.nvim_win_get_cursor(0)[1]
  vim.cmd('bd ' .. m.buffers[cursor_row].bufnr)
  m.update_view()
end

function m.go_to_buffer()
  local cursor_row = api.nvim_win_get_cursor(0)[1]
  if m.entries[cursor_row].winid ~= '/' then
    api.nvim_set_current_win(m.entries[cursor_row].winid)
  else
    vim.cmd("tabnew | b " .. m.entries[cursor_row].bufnr .. " | bd #")
  end
  m.close_window()
end

function m.show_window()
  m.open_window()
  m.update_view()
  m.set_mappings()
  vim.api.nvim_win_set_cursor(m.win, { 1, 0 })
end

return m
