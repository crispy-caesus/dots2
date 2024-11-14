return {
    'epwalsh/obsidian.nvim',
    version = '*', -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = 'markdown',
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    --   -- refer to `:h file-pattern` for more examples
    --   "BufReadPre path/to/my-vault/*.md",
    --   "BufNewFile path/to/my-vault/*.md",
    -- },
    dependencies = {
        -- Required.
        'nvim-lua/plenary.nvim',
        'hrsh7th/nvim-cmp',

        -- see below for full list of optional dependencies 👇
    },
    opts = {
        workspaces = {
            {
                name = 'obsidian',
                path = '~/Documents/obsidian',
            },
        },
        completion = {
            -- Set to false to disable completion.
            nvim_cmp = true,
            -- Trigger completion at 2 chars.
            min_chars = 2,
        },

        -- see below for full list of options 👇
    },
    vim.keymap.set('n', '<leader>oo', ':ObsidianQuickSwitch<cr>', { desc = '[O]bsidian [O]pen File' }),
    vim.keymap.set('n', '<leader>on', ':ObsidianNew<cr>', { desc = '[O]bsidian [N]ew' }),
    vim.keymap.set('n', '<leader>ofv', ':ObsidianFollowLink vsplit<cr>',
        { desc = '[O]bsidian [F]ollow Link [V]ertically' }),
    vim.keymap.set('n', '<leader>ofh', ':ObsidianFollowLink hsplit<cr>',
        { desc = '[O]bsidian [F]ollow Link [H]orizontally' }),
    vim.keymap.set('n', '<leader>ob', ':ObsidianBacklinks<cr>', { desc = '[O]bsidian [B]acklinks' }),
    vim.keymap.set('n', '<leader>os', ':ObsidianSearch<cr>', { desc = '[O]bsidian [S]earch' }),
    vim.keymap.set('v', '<leader>oe', ':ObsidianExtractNote<cr>', { desc = '[O]bsidian [E]xtract' }),
    vim.keymap.set('n', '<leader>or', ':ObsidianRename<cr>', { desc = '[O]bsidian [R]ename' }),
    vim.keymap.set('n', '<leader>ot', ':ObsidianTOC<cr>', { desc = '[O]bsidian [T]OC' }),
}
