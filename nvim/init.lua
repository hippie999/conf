vim.o.autocomplete = true
vim.o.autocompletedelay = 300
vim.o.clipboard = 'unnamedplus'
vim.o.cursorline = true
vim.o.cursorlineopt = 'number'
vim.o.expandtab = true
-- vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldlevel = 999
vim.o.foldmethod = 'expr'
vim.o.foldtext = ''
vim.o.grepprg = 'rg --vimgrep --no-messages --smart-case'
vim.o.ignorecase = true
vim.o.langmap = [=[ЁЙЦУКЕНГШЩЗХЪФЫВАПРОЛДЖЭЯЧСМИТЬБЮ;~QWERTYUIOP{}ASDFGHJKL:\"ZXCVBNM<>,ёйцукенгшщзхъфывапролджэячсмитьбю;`qwertyuiop[]asdfghjkl\;'zxcvbnm\,.]=]
vim.o.lazyredraw = true
vim.o.linebreak = true
vim.o.number = true
vim.o.numberwidth = 3
vim.o.relativenumber = true
vim.o.scrolloff = 5
vim.o.shiftwidth = 4
vim.o.smartcase = true
vim.o.smoothscroll = true
vim.o.splitright = true
vim.o.swapfile = false
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.o.updatetime = 900
vim.opt.dictionary:append('~/download/russian.utf-8')
vim.opt.guicursor:append('t:block-blinkon0-blinkoff0')
vim.opt.nrformats:append('blank')
vim.opt.path:append { '**' }
vim.opt.wildoptions:append('fuzzy')
-- vim.opt.runtimepath:append('/usr/share/tree-sitter')

vim.g.mapleader = ' '
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3

vim.cmd("syntax off")
vim.cmd.colorscheme('gruv1')
vim.cmd.packadd('cfilter')
vim.cmd.packadd('nohlsearch')
vim.cmd.packadd('nvim.difftool')
vim.cmd.packadd('nvim.undotree')

require('vim._core.ui2').enable {}

vim.pack.add {
    'https://github.com/neovim/nvim-lspconfig',
}

vim.lsp.enable({ 'lua_ls', 'clangd', 'ty', 'sqls', 'texlab', 'rust_analyzer', 'jdtls' })

vim.api.nvim_set_keymap('i', '<Tab>', 'pumvisible() ? "<Down>" : "<Tab>"', {expr = true, noremap = true})
vim.api.nvim_set_keymap('i', '<S-Tab>', 'pumvisible() ? "<Up>" : "<S-Tab>"', {expr = true, noremap = true})
vim.api.nvim_set_keymap('i', '<CR>', 'pumvisible() ? "<C-Y>" : "<CR>"', { expr = true, noremap = true })

vim.api.nvim_create_autocmd('FileType', {
    callback = function() pcall(vim.treesitter.start) end,
})

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        vim.o.signcolumn = 'yes:1'
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        if client:supports_method('textDocument/completion') then
            vim.o.complete = 'o,.,w,b,u'
            vim.o.completeopt = 'menu,menuone,popup,noinsert'
            vim.lsp.completion.enable(true, client.id, args.buf)
        end
    end
})

vim.api.nvim_create_autocmd('TermOpen', {
    callback = function()
        vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true, buffer = true })
    end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'html', 'markdown', 'tex', 'json', 'jsonc', 'kdl', 'css', 'lua', 'sql' },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
  end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'text', 'markdown', 'tex' },
    callback = function()
        vim.o.spell = true
        vim.o.spelllang = 'ru,en'
        vim.o.spellfile = '~/.config/nvim/spell/ru-en.utf-8.add'
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    callback = function()
        local filename = vim.fn.expand('%')
        local output = vim.fn.expand('%:r') .. '.pdf'
        vim.o.makeprg = 'pandoc --read=markdown+tex_math_dollars+tex_math_single_backslash ' ..
            filename .. ' -o ' .. output ..
            ' --pdf-engine=tectonic -V mainfont="Libertinus Serif"'
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'c',
    callback = function()
        vim.o.makeprg = 'gcc -Wall -Wextra -Wconversion -Wshadow %'
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'cpp',
    callback = function()
        vim.o.makeprg = 'g++ -g $CXXFLAG %'
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    callback = function()
        vim.o.makeprg = 'python %'
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'tex',
    callback = function()
        vim.o.makeprg = 'tectonic %' -- 'latexmk -pdf -aux-directory=/tmp/ %'
    end,
})
