if vim.g.loaded_tempaste then
  return
end
vim.g.loaded_tempaste = true

vim.api.nvim_create_user_command("Tempaste", function(opts)
  require("tempaste").apply(opts.args)
end, {
  nargs = 1,
  complete = function(arg_lead)
    return require("tempaste").complete(arg_lead)
  end,
})
