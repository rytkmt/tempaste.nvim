local M = {}

M.defaults = {
  templates_dir = nil,
  filetype_templates_dir = nil,
}

M.options = {}

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", {}, M.defaults, opts or {})
end

return M
