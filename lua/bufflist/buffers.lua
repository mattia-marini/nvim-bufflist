local config = require("bufflist.config")
local m = {}

function m.parse_buffs()
  local buffs = vim.fn.getbufinfo({ bufloaded = 1 })
  local rv1 = {}

  for _, buffer in ipairs(buffs) do
    if config.filter_func(buffer) then
      table.insert(rv1,
        {
          name = buffer.name == "" and "[No Name]" or vim.fs.basename(buffer.name),
          full_name = buffer.name,
          bufnr = buffer.bufnr,
          windows = buffer.windows,
          hidden = buffer.hidden == 1 and true or false,
          --loaded = buffer.loaded == 1 and true or false
        })
    end
  end

  local rv2 = {}
  for _, buffer in ipairs(rv1) do
    if #(buffer.windows) >= 1 then
      for _, winid in ipairs(buffer.windows) do
        table.insert(rv2,
          {
            bufnr = buffer.bufnr,
            hidden = buffer.hidden and 'h' or 'a',
            name = buffer.name,
            winid = winid
          }
        )
      end
    else
      table.insert(rv2,
        {
          bufnr = buffer.bufnr,
          hidden = buffer.hidden and ' h ' or ' a ',
          name = buffer.name,
          winid = '/'
        }
      )
    end
  end
  return rv1, rv2
end

return m
