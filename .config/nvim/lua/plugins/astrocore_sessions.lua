return {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
        -- Configuration table of session options for AstroNvim's session management powered by Resession
        sessions = {
            -- Configure auto saving
            autosave = {
                last = true, -- Auto save last session
                cwd = true -- Auto save session for each working directory
            },
            -- Patterns to ignore when saving sessions
            ignore = {
                dirs = {}, -- Working directories to ignore sessions in
                filetypes = {"gitcommit", "gitrebase"}, -- Filetypes to ignore sessions
                buftypes = {} -- Buffer types to ignore sessions
            }
        }
    }
}

