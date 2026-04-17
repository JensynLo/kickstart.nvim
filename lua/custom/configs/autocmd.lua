-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})
vim.api.nvim_create_autocmd('BufWritePost', {
  -- 直接写通配符模式，匹配任何路径下以 /lua/custom/configs/ 结尾的 .lua 文件
  pattern = '*/lua/custom/configs/*.lua',
  callback = function(args) vim.cmd('source ' .. args.file) end,
})
