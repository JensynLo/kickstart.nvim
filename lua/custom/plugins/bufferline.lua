return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    local bufferline = require 'bufferline'

    require('bufferline').setup {
      options = {
        -- 设置侧边栏偏移，避开 Neo-tree
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'File Explorer', -- 显示在 Neo-tree 上方的标题（可以改成 "项目文件" 等）
            text_align = 'left', -- 标题对齐方式 ("left", "center", "right")
            separator = true, -- 是否在侧边栏和标签页之间显示一条竖状分割线
          },
        },

        -- 下面是你刚才提供的 groups 配置，它同样放在 options 里面
        groups = {
          options = {
            toggle_hidden_on_enter = true,
          },
          items = {
            -- ... 你的 items 配置 ...
          },
        },
        style_preset = bufferline.style_preset.minimal,
        separator_style = 'slope',
      },
    }
  end,
}
