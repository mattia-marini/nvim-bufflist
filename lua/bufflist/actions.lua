local ui = require("bufflist.ui")

local m = {
  open_window = ui.show_window,
  close_window = ui.close_window,
  go_to_buffer = ui.go_to_buffer,
  close_buffer = ui.close_buffer,
}

return m
