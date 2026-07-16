local config = require("tempaste.config")

local M = {}

function M.setup(opts)
  config.setup(opts)
end

local function expand_path(path)
  if not path then
    return path
  end
  return vim.fn.expand(path)
end

local function list_files(dir)
  dir = expand_path(dir)
  if not dir or vim.fn.isdirectory(dir) == 0 then
    return {}
  end
  local files = {}
  local entries = vim.fn.globpath(dir, "**/*", false, true)
  for _, entry in ipairs(entries) do
    if vim.fn.isdirectory(entry) == 0 then
      table.insert(files, vim.fn.fnamemodify(entry, ":t"))
    end
  end
  return files
end

local function find_file(dirs, filename)
  for _, dir in ipairs(dirs) do
    dir = expand_path(dir)
    if dir and vim.fn.isdirectory(dir) == 1 then
      local matches = vim.fn.globpath(dir, "**/" .. filename, false, true)
      if #matches > 0 then
        return matches[1]
      end
    end
  end
  return nil
end

function M.get_template_dirs()
  local dirs = {}
  local opts = config.options

  if opts.templates_dir then
    table.insert(dirs, opts.templates_dir)
  end

  if opts.filetype_templates_dir then
    local ft = vim.bo.filetype
    if ft and ft ~= "" then
      local ft_dir = expand_path(opts.filetype_templates_dir) .. "/" .. ft
      if vim.fn.isdirectory(ft_dir) == 1 then
        table.insert(dirs, ft_dir)
      end
    end
  end

  return dirs
end

function M.get_templates()
  local dirs = M.get_template_dirs()
  local templates = {}
  local seen = {}

  for _, dir in ipairs(dirs) do
    for _, file in ipairs(list_files(dir)) do
      if not seen[file] then
        seen[file] = true
        table.insert(templates, file)
      end
    end
  end

  table.sort(templates)
  return templates
end

function M.get_template_files()
  local dirs = M.get_template_dirs()
  local files = {}

  for _, dir in ipairs(dirs) do
    dir = expand_path(dir)
    if dir and vim.fn.isdirectory(dir) == 1 then
      local entries = vim.fn.globpath(dir, "**/*", false, true)
      for _, entry in ipairs(entries) do
        if vim.fn.isdirectory(entry) == 0 then
          table.insert(files, {
            name = vim.fn.fnamemodify(entry, ":t"),
            path = entry,
          })
        end
      end
    end
  end

  return files
end

function M.apply(filename)
  if not filename or filename == "" then
    vim.notify("[tempaste] No template specified", vim.log.levels.ERROR)
    return
  end

  local dirs = M.get_template_dirs()
  local filepath = find_file(dirs, filename)

  if not filepath then
    vim.notify("[tempaste] Template not found: " .. filename, vim.log.levels.ERROR)
    return
  end

  local lines = vim.fn.readfile(filepath)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.notify("[tempaste] Applied template: " .. filename)
end

function M.complete(arg_lead)
  local templates = M.get_templates()
  local results = {}
  for _, name in ipairs(templates) do
    if name:find(arg_lead, 1, true) == 1 then
      table.insert(results, name)
    end
  end
  return results
end

return M
