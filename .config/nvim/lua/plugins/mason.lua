if true then
    return {}
end -- WARN: REMOVE THESE LINES TO ACTIVATE THIS FILE

-- Customize Mason

---@type LazySpec
return {
    -- Use mason-tool-installer for automatically installing Mason packages
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        -- Overrides `require("mason-tool-installer").setup(...)`
        opts = {
            -- Make sure to use the names found in `:Mason`
            ensure_installed = {
                -- Install language servers
                "lua-language-server",
                -- Install formatters
                "stylua",
                -- Install debuggers
                "debugpy",
                -- Install any other package
                "tree-sitter-cli"
            }
        }
    }
}

