-- Function for calculating the current session name
local get_session_name = function()
    local name = vim.fn.getcwd()
    local branch = vim.fn.system("git branch --show-current")
    if vim.v.shell_error == 0 then
        return name .. vim.trim(branch --[[@as string]])
    else
        return name
    end
end

return {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
        sessions = {
            -- Disable the auto-saving of directory sessions
            autosave = {cwd = false}
        },
        mappings = {
            n = {
                -- Update save dirsession mapping to get the correct session name
                ["<Leader>SS"] = {
                    function()
                        require("resession").save(get_session_name(), {dir = "dirsession"})
                    end,
                    desc = "Save this dirsession"
                },
                -- Update load dirsession mapping to get the correct session name
                ["<Leader>S."] = {
                    function()
                        require("resession").load(get_session_name(), {dir = "dirsession"})
                    end,
                    desc = "Load current dirsession"
                }
            }
        },
        autocmds = {
            git_branch_sessions = {
                -- Auto save directory sessions on leaving
                {
                    event = "VimLeavePre",
                    desc = "Save git branch directory sessions on close",
                    callback = vim.schedule_wrap(
                        function()
                            if require("astrocore.buffer").is_valid_session() then
                                require("resession").save(get_session_name(), {dir = "dirsession", notify = false})
                            end
                        end
                    )
                },
                -- Auto restore previous previous directory session
                {
                    event = "VimEnter",
                    desc = "Restore previous directory session if neovim opened with no arguments",
                    nested = true, -- Trigger other autocommands as buffers open
                    callback = function()
                        -- Only load the session if Neovim was started with no arguments
                        if vim.fn.argc(-1) == 0 then
                            -- Try to load a directory session using the current working directory
                            require("resession").load(get_session_name(), {dir = "dirsession", silence_errors = true})
                        end
                    end
                }
            }
        }
    }
}

