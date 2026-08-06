-- A small, self-contained selection of LazyVim's navigation and IDE features.
-- This intentionally does not import LazyVim itself, so the existing Kickstart
-- LSP, completion, formatting, and language configuration remain authoritative.

local function project_root()
  local bufname = vim.api.nvim_buf_get_name(0)
  local start = bufname ~= '' and vim.fs.dirname(bufname) or (vim.uv or vim.loop).cwd()
  local root = vim.fs.root(start, { '.git', 'composer.json', 'package.json', 'pyproject.toml' })
  if root then
    return root
  end

  local solution = vim.fs.find(function(name)
    return name:match '%.slnx?$' ~= nil
  end, { path = start, upward = true, type = 'file' })[1]

  return solution and vim.fs.dirname(solution) or (vim.uv or vim.loop).cwd()
end

return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      bufdelete = { enabled = true },
      explorer = { enabled = true },
      picker = {
        enabled = true,
        layout = {
          preset = 'ivy',
        },
      },
    },
    keys = {
      -- LazyVim-style file and buffer navigation.
      {
        '<leader><space>',
        function()
          Snacks.picker.files { cwd = project_root() }
        end,
        desc = 'Find Files (Project Root)',
      },
      {
        '<leader>,',
        function()
          Snacks.picker.buffers()
        end,
        desc = 'Switch Buffer',
      },
      {
        '<leader>/',
        function()
          Snacks.picker.grep { cwd = project_root() }
        end,
        desc = 'Grep (Project Root)',
      },
      {
        '<leader>:',
        function()
          Snacks.picker.command_history()
        end,
        desc = 'Command History',
      },
      {
        '<leader>e',
        function()
          Snacks.explorer { cwd = project_root() }
        end,
        desc = 'Explorer (Project Root)',
      },
      {
        '<leader>E',
        function()
          Snacks.explorer()
        end,
        desc = 'Explorer (Current Directory)',
      },
      {
        '<leader>ff',
        function()
          Snacks.picker.files { cwd = project_root() }
        end,
        desc = 'Find Files (Project Root)',
      },
      {
        '<leader>fF',
        function()
          Snacks.picker.files()
        end,
        desc = 'Find Files (Current Directory)',
      },
      {
        '<leader>fg',
        function()
          Snacks.picker.git_files()
        end,
        desc = 'Find Git Files',
      },
      {
        '<leader>fr',
        function()
          Snacks.picker.recent()
        end,
        desc = 'Recent Files',
      },
      {
        '<leader>fb',
        function()
          Snacks.picker.buffers()
        end,
        desc = 'Buffers',
      },
      {
        '<leader>bd',
        function()
          Snacks.bufdelete()
        end,
        desc = 'Delete Buffer',
      },
      { '<S-h>', '<cmd>bprevious<cr>', desc = 'Previous Buffer' },
      { '<S-l>', '<cmd>bnext<cr>', desc = 'Next Buffer' },
      { '[b', '<cmd>bprevious<cr>', desc = 'Previous Buffer' },
      { ']b', '<cmd>bnext<cr>', desc = 'Next Buffer' },
    },
  },

  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    keys = {
      { '<leader>bp', '<cmd>BufferLineTogglePin<cr>', desc = 'Toggle Buffer Pin' },
      { '<leader>bP', '<cmd>BufferLineGroupClose ungrouped<cr>', desc = 'Delete Non-Pinned Buffers' },
      { '<leader>bo', '<cmd>BufferLineCloseOthers<cr>', desc = 'Delete Other Buffers' },
      { '<leader>br', '<cmd>BufferLineCloseRight<cr>', desc = 'Delete Buffers to the Right' },
      { '<leader>bl', '<cmd>BufferLineCloseLeft<cr>', desc = 'Delete Buffers to the Left' },
    },
    opts = {
      options = {
        diagnostics = 'nvim_lsp',
        always_show_bufferline = false,
        show_buffer_icons = vim.g.have_nerd_font,
        show_buffer_close_icons = false,
        separator_style = 'thin',
      },
    },
  },

  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    opts = {
      routes = {
        {
          filter = {
            event = 'msg_show',
            any = {
              { find = '%d+L, %d+B' },
              { find = '; after #%d+' },
              { find = '; before #%d+' },
            },
          },
          view = 'mini',
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
    },
    keys = {
      {
        '<S-Enter>',
        function()
          require('noice').redirect(vim.fn.getcmdline())
        end,
        mode = 'c',
        desc = 'Redirect Command Output',
      },
      {
        '<leader>mh',
        function()
          require('noice').cmd 'history'
        end,
        desc = 'Message History',
      },
      {
        '<leader>md',
        function()
          require('noice').cmd 'dismiss'
        end,
        desc = 'Dismiss Messages',
      },
    },
  },

  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    opts = {},
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Workspace Diagnostics' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics' },
      { '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Document Symbols' },
      { '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP Definitions/References' },
      { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location List' },
      { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List' },
    },
  },

  {
    'stevearc/aerial.nvim',
    cmd = { 'AerialOpen', 'AerialToggle' },
    keys = {
      { '<leader>co', '<cmd>AerialToggle! right<cr>', desc = 'Code Outline' },
      { '[s', '<cmd>AerialPrev<cr>', desc = 'Previous Symbol' },
      { ']s', '<cmd>AerialNext<cr>', desc = 'Next Symbol' },
    },
    opts = {
      attach_mode = 'global',
      backends = { 'lsp', 'treesitter', 'markdown', 'man' },
      show_guides = true,
      layout = {
        resize_to_content = false,
        min_width = 28,
      },
    },
  },
}
