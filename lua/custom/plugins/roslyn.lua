return {
  {
    'seblyng/roslyn.nvim',
    lazy = false,
    dependencies = {
      'neovim/nvim-lspconfig',
      'saghen/blink.cmp',
    },
    opts = {
      broad_search = true,
    },
    config = function(_, opts)
      local uv = vim.uv or vim.loop
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local dotnet = vim.fn.exepath 'dotnet'
      local homebrew_dotnet = '/opt/homebrew/bin/dotnet'
      local mason_roslyn = vim.fs.joinpath(
        vim.fn.stdpath 'data',
        'mason',
        'packages',
        'roslyn',
        'libexec',
        'Microsoft.CodeAnalysis.LanguageServer.dll'
      )
      local dotnet_root = '/opt/homebrew/opt/dotnet/libexec'
      local roslyn_cmd = nil
      local roslyn_env = nil

      if dotnet == '' and uv.fs_stat(homebrew_dotnet) then
        dotnet = homebrew_dotnet
      end

      if dotnet ~= '' and uv.fs_stat(mason_roslyn) then
        roslyn_cmd = {
          dotnet,
          mason_roslyn,
          '--logLevel',
          'Information',
          '--extensionLogDirectory',
          vim.fs.joinpath(vim.uv.os_tmpdir(), 'roslyn_ls', 'logs'),
          '--stdio',
        }
      end

      if uv.fs_stat(dotnet_root) then
        roslyn_env = { DOTNET_ROOT = dotnet_root }
      end

      vim.lsp.config('roslyn', {
        cmd = roslyn_cmd,
        cmd_env = roslyn_env,
        capabilities = vim.tbl_deep_extend('force', {}, capabilities),
        settings = {
          ['csharp|background_analysis'] = {
            dotnet_analyzer_diagnostics_scope = 'fullSolution',
            dotnet_compiler_diagnostics_scope = 'fullSolution',
          },
          ['csharp|code_lens'] = {
            dotnet_enable_references_code_lens = true,
            dotnet_enable_tests_code_lens = true,
          },
          ['csharp|completion'] = {
            dotnet_provide_regex_completions = true,
            dotnet_show_completion_items_from_unimported_namespaces = true,
            dotnet_show_name_completion_suggestions = true,
          },
          ['csharp|inlay_hints'] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
          },
          ['csharp|symbol_search'] = {
            dotnet_search_reference_assemblies = true,
          },
        },
      })

      require('roslyn').setup(opts)
    end,
  },
}
