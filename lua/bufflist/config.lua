return {
  filter_func = function(buffer)
    return
        (buffer.listed == 1 or (buffer.hidden == 0 and buffer.name ~= ''))
        and (vim.api.nvim_get_option_value('filetype', { buf = buffer.bufnr }) ~= 'bufferlist')
  end,
  mappings = {
    ['<esc>'] = function() require("bufflist.actions").close_window() end,
    ['<cr>'] = function() require("bufflist.actions").go_to_buffer() end,
    ["l"] = function() require("bufflist.actions").go_to_buffer() end,
    ["h"] = function() require("bufflist.actions").close_buffer() end,
    ["d"] = function() require("bufflist.actions").close_buffer() end,
    ["q"] = function() require("bufflist.actions").close_window() end,
  }
}
