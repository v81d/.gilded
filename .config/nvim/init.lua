----------------------------------------------
-- ASTRONVIM DEFAULTS ------------------------
----------------------------------------------


local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
    -- stylua: ignore
    local result =
        vim.fn.system(
        {"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath}
    )
    if vim.v.shell_error ~= 0 then
        -- stylua: ignore
        vim.api.nvim_echo(
            {{("Error cloning lazy.nvim:\n%s\n"):format(result), "ErrorMsg"}, {"Press any key to exit...", "MoreMsg"}},
            true,
            {}
        )
        vim.fn.getchar()
        vim.cmd.quit()
    end
end

vim.opt.rtp:prepend(lazypath)

-- Validate that lazy is available

if not pcall(require, "lazy") then
    -- stylua: ignore
    vim.api.nvim_echo(
        {{("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg"}, {"Press any key to exit...", "MoreMsg"}},
        true,
        {}
    )
    vim.fn.getchar()
    vim.cmd.quit()
end

require "lazy_setup"
require "polish"

local nvimstate = vim.fn.stdpath("data") .. "/nvimstate"


----------------------------------------------
-- MISCELLANEOUS FEATURES --------------------
----------------------------------------------


-- On exit, record whether Neo-tree was open

vim.api.nvim_create_autocmd(
    "VimLeavePre",
    {
        callback = function()
            local wins = vim.api.nvim_list_wins()
            local neotree_open = false
            for _, w in ipairs(wins) do
                local ft = vim.api.nvim_get_option_value("filetype", {buf = vim.api.nvim_win_get_buf(w)})
                if ft == "neo-tree" then
                    neotree_open = true
                    break
                end
            end
            vim.fn.writefile({"neo-tree_open = " .. tostring(neotree_open)}, nvimstate)
        end
    }
)

-- On startup, reopen if it was open at last exit

vim.api.nvim_create_autocmd(
    "VimEnter",
    {
        callback = function()
            if vim.fn.filereadable(nvimstate) == 1 then
                local data = vim.fn.readfile(nvimstate)
                if data[1] and string.find(data[1], "neo%-tree_open = true") then
                    vim.cmd("Neotree show")
                end
            end
        end
    }
)

-- Get the working directory

local function get_editing_buffer_dir()
    -- Iterate over all windows
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buf_name = vim.api.nvim_buf_get_name(buf)
        local buf_type = vim.api.nvim_get_option_value("buftype", {buf = buf})

        -- Check if it's a normal file buffer
        -- For normal files, buf_type is an empty string, but for special buffers, the buf_type will be a specific string
        if buf_type == "" and buf_name ~= "" then
            return vim.fn.fnamemodify(buf_name, ":p:h")
        end
    end
    return vim.fn.getcwd() -- Fallback to the directory of the current buffer
end

-- Integrated terminal keybind

vim.keymap.set(
    "n",
    "<Leader>tt",
    function()
        local cwd = get_editing_buffer_dir()

        local Terminal = require("toggleterm.terminal").Terminal
        local term =
            Terminal:new(
            {
                cmd = 'fish --init-command=\'cd "' .. cwd .. '" || fish\'',
                direction = "horizontal",
                close_on_exit = false
            }
        )
        term:toggle()
    end,
    {desc = "ToggleTerm integrated"}
)

-- Launch Lazygit

vim.keymap.set(
    "n",
    "<Leader>gg",
    function()
        local cwd = get_editing_buffer_dir()

        local Terminal = require("toggleterm.terminal").Terminal
        local term =
            Terminal:new(
            {
                cmd = "fish --init-command='cd " .. cwd .. " || fish && lazygit && exit'",
                direction = "float"
            }
        )
        term:toggle()
    end,
    {desc = "ToggleTerm integrated"}
)

-- Normal mode remap: select panes

vim.keymap.set("n", "<C-h>", "<C-w>h", {noremap = true, silent = true})
vim.keymap.set("n", "<C-j>", "<C-w>j", {noremap = true, silent = true})
vim.keymap.set("n", "<C-k>", "<C-w>k", {noremap = true, silent = true})
vim.keymap.set("n", "<C-l>", "<C-w>l", {noremap = true, silent = true})

-- Switch buffer

vim.keymap.set("n", "<A-l>", ":bn<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<A-h>", ":bp<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<A-Right>", ":bn<CR>", {noremap = true, silent = true})
vim.keymap.set("n", "<A-Left>", ":bp<CR>", {noremap = true, silent = true})

-- Disable yank-on-delete

vim.keymap.set({"n", "v"}, "d", '"_d', {noremap = true, silent = true, desc = "Black-hole delete"})
vim.keymap.set({"n", "v"}, "dd", '"_dd', {noremap = true, silent = true, desc = "Black-hole delete"})

-- Ensure one blank line at EOF before saving any file

vim.api.nvim_create_augroup("ensure_trailing_newline", {})

vim.api.nvim_create_autocmd(
    "BufWritePre",
    {
        group = "ensure_trailing_newline",
        pattern = "*",
        callback = function()
            local bufnr = 0
            local lines = vim.api.nvim_buf_get_lines(bufnr, -2, -1, true)
            local last = lines[1] or ""
            if last ~= "" then
                vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, {""})
            end
        end,
        desc = "Append one blank line at EOF if missing"
    }
)

