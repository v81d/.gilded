if true then
    return {}
end -- WARN: REMOVE THESE LINES TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
    "AstroNvim/astrocommunity",
    {import = "astrocommunity.pack.lua"}
    -- Import/override with your plugins folder
}

