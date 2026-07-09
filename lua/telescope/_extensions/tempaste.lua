local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  error("tempaste.nvim requires telescope.nvim")
end

local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local previewers = require("telescope.previewers")

local function run(opts)
  opts = opts or {}
  local tempaste = require("tempaste")
  local files = tempaste.get_template_files()

  if #files == 0 then
    vim.notify("[tempaste] No templates found for filetype: " .. vim.bo.filetype, vim.log.levels.WARN)
    return
  end

  pickers.new(opts, {
    prompt_title = "Tempaste",
    finder = finders.new_table({
      results = files,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.name,
          ordinal = entry.name,
          path = entry.path,
        }
      end,
    }),
    sorter = conf.generic_sorter(opts),
    previewer = previewers.new_buffer_previewer({
      title = "Template Preview",
      define_preview = function(self, entry)
        local lines = vim.fn.readfile(entry.path)
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
        local ft = vim.filetype.match({ filename = entry.path })
        if ft then
          vim.bo[self.state.bufnr].filetype = ft
        end
      end,
    }),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection then
          tempaste.apply(selection.value.name)
        end
      end)
      return true
    end,
  }):find()
end

return telescope.register_extension({
  exports = {
    tempaste = run,
  },
})
