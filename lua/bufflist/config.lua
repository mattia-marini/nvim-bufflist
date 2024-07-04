local actions = require("bufflist.actions")
return {
  filter_func = {
    function(buffer)
      return
          (buffer.listed == 1 or (buffer.hidden == 0 and buffer.name ~= ''))
          and (vim.api.nvim_get_option_value('filetype', { buf = buffer.bufnr }) ~= 'bufferlist')
    end
  },
  mappings = {
    ['<esc>'] = actions.close_window,
    ['<cr>'] = actions.go_to_buffer,
    ["l"] = actions.go_to_buffer,
    ["h"] = actions.close_buffer,
    ["d"] = actions.close_buffer,
    ["q"] = actions.close_window,
  }
}
