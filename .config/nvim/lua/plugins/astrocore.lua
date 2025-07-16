if true then
    return {}
end -- WARN: REMOVE THESE LINES TO ACTIVATE THIS FILE

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
        -- Configure core features of AstroNvim
        features = {
            large_buf = {size = 1024 * 256, lines = 10000}, -- Set global limits for large files for disabling features like treesitter
            autopairs = true, -- Enable autopairs at start
            cmp = true, -- Enable completion at start
            diagnostics = {virtual_text = true, virtual_lines = false}, -- Diagnostic settings on startup
            highlighturl = true, -- Highlight URLs at start
            notifications = true -- Enable notifications at start
        },
        -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
        diagnostics = {
            virtual_text = true,
            underline = true
        },
        -- Passed to `vim.filetype.add`
        filetypes = {
            -- See `:h vim.filetype.add` for usage
            extension = {
                foo = "fooscript"
            },
            filename = {
                [".foorc"] = "fooscript"
            },
            pattern = {
                [".*/etc/foo/.*"] = "fooscript"
            }
        },
        -- Vim options can be configured here
        options = {
            opt = {
                -- vim.opt.<key>
                relativenumber = true, -- Sets vim.opt.relativenumber
                number = true, -- Sets vim.opt.number
                spell = false, -- Sets vim.opt.spell
                signcolumn = "yes", -- Sets vim.opt.signcolumn to yes
                wrap = false -- Sets vim.opt.wrap
            },
            g = {}
        },
        -- Mappings can be configured through AstroCore as well.
        -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
        mappings = {
            -- First key is the mode
            n = {
                -- Second key is the lefthand side of the map

                -- Navigate buffer tabs
                ["]b"] = {function()
                        require("astrocore.buffer").nav(vim.v.count1)
                    end, desc = "Next buffer"},
                ["[b"] = {function()
                        require("astrocore.buffer").nav(-vim.v.count1)
                    end, desc = "Previous buffer"},
                -- Mappings seen under group name "Buffer"
                ["<Leader>bd"] = {
                    function()
                        require("astroui.status.heirline").buffer_picker(
                            function(bufnr)
                                require("astrocore.buffer").close(bufnr)
                            end
                        )
                    end,
                    desc = "Close buffer from tabline"
                }

                -- Tables with just a `desc` key will be registered with which-key if it's installed
                -- This is useful for naming menus
                -- ["<Leader>b"] = { desc = "Buffers" },

                -- Setting a mapping to false will disable it
                -- ["<C-S>"] = false,
            }
        }
    }
}

