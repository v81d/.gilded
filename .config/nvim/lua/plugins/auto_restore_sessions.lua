return {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
        autocmds = {
            restore_session = {
                {
                    event = "VimEnter",
                    desc = "Restore previous directory session if neovim opened with no arguments",
                    nested = true, -- Trigger other autocommands as buffers open
                    callback = function()
                        -- Only load the session if nvim was started with no args
                        if vim.fn.argc(-1) == 0 then
                            -- Try to load a directory session using the current working directory
                            require("resession").load(vim.fn.getcwd(), {dir = "dirsession", silence_errors = true})
                        end
                    end
                }
            }
        }
    }
}

