require("bufflist.ui")
require("bufflist.config")
require("bufflist.buffers")
require("bufflist.mappings")
require("bufflist.actions")

vim.api.nvim_set_keymap('n', '<Space>F', '', {callback = function () require("bufflist.actions").open_window() end})

return {config = function(user_conf)
  local config_table = require("bufflist.config")
  for key, value in pairs(user_conf) do
    config_table[key]=value
  end
end}
