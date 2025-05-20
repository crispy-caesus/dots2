return {
    {
        'williamboman/mason.nvim',
        lazy = false,
        opts = {},
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        config = function()
            local cmp = require('cmp')

            local cmp_select = { behavior = cmp.SelectBehavior.Select }

            cmp.setup({
                sources = {
                    { name = 'nvim_lsp' },
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                }),
                snippet = {
                    expand = function(args)
                        vim.snippet.expand(args.body)
                    end,
                },
            })
        end
    },

    -- LSP
    {
        'neovim/nvim-lspconfig',
        cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
        event = { 'BufReadPre', 'BufNewFile' },
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
        },
        init = function()
            -- Reserve a space in the gutter
            -- This will avoid an annoying layout shift in the screen
            vim.opt.signcolumn = 'yes'
        end,
        config = function()
            local lsp_defaults = require('lspconfig').util.default_config

            -- Add cmp_nvim_lsp capabilities settings to lspconfig
            -- This should be executed before you configure any language server
            lsp_defaults.capabilities = vim.tbl_deep_extend(
                'force',
                lsp_defaults.capabilities,
                require('cmp_nvim_lsp').default_capabilities()
            )

            -- LspAttach is where you enable features that only work
            -- if there is a language server active in the file
            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(event)
                    local opts = { buffer = event.buf }

                    vim.keymap.set({ 'n', 'x' }, '<F3>',
                        '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)

                    vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions,
                        { desc = '[G]oto [D]efinition' })
                    vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references,
                        { desc = '[G]oto [R]eferences' })
                    vim.keymap.set('n', 'gI', require('telescope.builtin').lsp_implementations,
                        { desc = '[G]oto [I]mplementation' })
                    vim.keymap.set('n', 'gt',
                        require('telescope.builtin').lsp_type_definitions,
                        { desc = '[G]oto [T]ype Definition' })
                    vim.keymap.set('n', '<leader>ds',
                        require('telescope.builtin').lsp_document_symbols,
                        { desc = '[D]ocument [S]ymbols' })
                    vim.keymap.set('n', '<leader>ws',
                        require('telescope.builtin').lsp_dynamic_workspace_symbols,
                        { desc = '[W]orkspace [S]ymbols' })
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = '[R]e[n]ame' })
                    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action,
                        { desc = '[C]ode [A]ction' })
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover Documentation' })
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,
                        { desc = '[G]oto [D]eclaration' })
                end,
            })

            require "lspconfig".pylsp.setup {
                on_attach = on_attach,
                settings = {
                    pylsp = {
                        plugins = {
                            flake8 = {
                                enabled = false,
                                maxLineLength = 119,
                            },
                            mypy = {
                                enabled = true,
                            },
                            pycodestyle = {
                                enabled = false,
                            },
                            pyflakes = {
                                enabled = false,
                            },
                        }
                    }
                }
            }

            require("lspconfig").qmlls.setup {
                cmd = {"qmlls", "-E"}
            }

            require('mason-lspconfig').setup({
                ensure_installed = {},
                handlers = {
                    -- this first function is the "default handler"
                    -- it applies to every language server without a "custom handler"
                    function(server_name)
                        require('lspconfig')[server_name].setup({})
                    end,
                }
            })
        end
    }
}
