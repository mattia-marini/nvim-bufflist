local config = require("bufflist.config")
local api = vim.api

local m = {}

function m.set(buf)
  for k, v in pairs(config.mappings) do
    api.nvim_buf_set_keymap(buf, 'n', k, '', {
      nowait = true,
      noremap = true,
      silent = true,
      callback = v
    })
  end
end

return m
