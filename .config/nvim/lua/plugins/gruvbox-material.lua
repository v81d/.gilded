return {
    {
        "sainnhe/gruvbox-material",
        priority = 1000,
        config = function()
            -- Set options BEFORE setting the color scheme
            vim.g.gruvbox_material_background = "hard"
            vim.g.gruvbox_material_enable_italic = 1
            vim.g.gruvbox_material_foreground = "material"
            vim.cmd("colorscheme gruvbox-material")
        end
    }
}

