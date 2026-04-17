--  See `:help vim.keymap.set()`
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic Config & Keymaps
-- See :help vim.diagnostic.Opts
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },

  -- Can switch between these as you prefer
  virtual_text = true, -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  jump = { float = true },
}

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
-- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

local vimmap = vim.keymap.set

--- 批量映射多个键到同一个操作
---@param mode string|table 模式，例如 "n" 或 {"n", "i"}
---@param lhs string|table 触发键，例如 "<C-w>" 或 {"<C-w>", "<C-a>"}
---@param rhs string|function 执行的命令或 Lua 函数
---@param opts table|nil 额外选项 (可选)
local function map(mode, lhs, rhs, opts)
  opts = opts or { silent = true }

  -- 如果传入的是单个字符串，统一包装成表，方便后续遍历
  if type(lhs) == 'string' then lhs = { lhs } end

  -- 遍历所有的触发键，分别进行映射
  for _, key in ipairs(lhs) do
    vimmap(mode, key, rhs, opts)
  end
end

-- =====================================================================
-- 导航
-- =====================================================================
-- 光标移动
map('i', '<C-a>', '<Home>', { desc = 'Move to beginning of line' })
map('i', '<C-e>', '<End>', { desc = 'Move to end of line' })
map('i', '<C-f>', '<Right>', { desc = 'Move forward one character' })
map('i', '<C-b>', '<Left>', { desc = 'Move backward one character' })
map('i', '<C-p>', '<Up>', { desc = 'Move to previous line' })
map('i', '<C-n>', '<Down>', { desc = 'Move to next line' })

-- 快速编辑
map('i', '<C-d>', '<Del>', { desc = 'Delete character under cursor' })
map('i', '<C-k>', '<C-o>D', { desc = 'Kill line after cursor' })
-- 移动
map('n', '<enter>', 'ciw')

-- =====================================================================
-- 猎奇映射
-- =====================================================================
map({ 'n', 'v' }, 'L', '$')
map({ 'n', 'v' }, 'H', '^')
map({ 'n', 'v' }, 'J', '4j')
map({ 'n', 'v' }, 'K', '4k')
map({ 'n', 'v' }, ';', ':')
map('i', 'jk', '<esc>')

-- =====================================================================
-- Neotree
-- =====================================================================
map({ 'n' }, { '<leader>ee' }, '<cmd>Neotree toggle<cr>', { desc = 'Toggle Neo-tree' })
-- 展开侧边栏并定位到当前打开的文件 (Reveal & Focus)
map({ 'n' }, '<leader>ef', '<cmd>Neotree focus reveal<cr>', { desc = 'Reveal file in Neo-tree' })

-- 打开 Git 状态面板 (非常适合在提交前查看修改的文件)
map({ 'n' }, '<leader>eg', '<cmd>Neotree git_status float<cr>', { desc = 'Git status (Neo-tree)' })

-- 打开 Buffers 面板 (查看所有已打开的文件)
map({ 'n' }, { '<leader>eb', '<D-e>', '<M-e>' }, '<cmd>Neotree buffers float<cr>', { desc = 'Buffers (Neo-tree)' })

--

-- =====================================================================
-- 全局操作：融合 VS Code 与现代编辑器习惯
-- =====================================================================
-- 快速保存 (支持同时映射普通的 <C-s> 和 Mac 上的 Command-S)
map({ 'n', 'i', 'v' }, { '<C-s>', '<D-s>' }, '<cmd>w<cr><esc>', { desc = 'Save file', silent = true })

-- 多模式下的复制粘贴系统剪贴板 (与系统行为对齐)
map({ 'n', 'v' }, '<D-c>', '"+y', { desc = 'Copy to system clipboard' })
map({ 'n', 'v', 'i' }, '<D-v>', function()
  -- 在 Insert 模式下粘贴时，使用 <C-r>+ 更加原生
  if vim.fn.mode() == 'i' then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-r>+', true, true, true), 'n', true)
  else
    vim.cmd 'normal! "+p'
  end
end, { desc = 'Paste from system clipboard' })

-- =====================================================================
-- 其他
-- =====================================================================
-- 使用 Tab 和 Shift-Tab 在 Buffer 之间切换 (类似浏览器的标签页)
map('n', '<Tab>', '<cmd>bnext<cr>', { desc = 'Next buffer' })
map('n', '<S-Tab>', '<cmd>bprevious<cr>', { desc = 'Previous buffer' })

-- =====================================================================
-- Telescope 快捷键
-- =====================================================================
map('n', '<leader>sh', '<cmd>Telescope help_tags<cr>', { desc = '[S]earch [H]elp' })
map('n', '<leader>sk', '<cmd>Telescope keymaps<cr>', { desc = '[S]earch [K]eymaps' })
map('n', '<leader>sf', '<cmd>Telescope find_files<cr>', { desc = '[S]earch [F]iles' })
map('n', '<leader>ss', '<cmd>Telescope lsp_document_symbols<cr>', { desc = '[S]earch [S]ymbols' })
map({ 'n', 'v' }, '<leader>sw', '<cmd>Telescope grep_string<cr>', { desc = '[S]earch current [W]ord' })
map('n', '<leader>sg', '<cmd>Telescope live_grep<cr>', { desc = '[S]earch by [G]rep' })
map('n', '<leader>sd', '<cmd>Telescope diagnostics<cr>', { desc = '[S]earch [D]iagnostics' })
map('n', '<leader>sr', '<cmd>Telescope resume<cr>', { desc = '[S]earch [R]esume' })
map('n', '<leader>s.', '<cmd>Telescope oldfiles<cr>', { desc = '[S]earch Recent Files ("." for repeat)' })
map('n', '<leader>sc', '<cmd>Telescope commands<cr>', { desc = '[S]earch [C]ommands' })
map('n', '<leader><leader>', '<cmd>Telescope buffers<cr>', { desc = '[ ] Find existing buffers' })
map('n', '<leader>sS', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>', { desc = '[S]earch Workspace [S]ymbols' })
map('n', '<leader>s"', '<cmd>Telescope registers<cr>', { desc = '[S]earch Registers (" for clipboard)' })
map('n', '<leader>sm', '<cmd>Telescope marks<cr>', { desc = '[S]earch [M]arks' })
map('n', '<leader>sp', '<cmd>Telescope builtin<cr>', { desc = '[S]earch [P]ickers (Telescope Builtins)' })
