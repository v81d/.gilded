return {
  {
    "sainnhe/gruvbox-material",
    priority = 1000,
    config = function()
      -- Set options BEFORE setting the colorscheme
      vim.g.gruvbox_material_background = "hard" -- or "hard"/"soft"
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_foreground = "material"
      vim.cmd("colorscheme gruvbox-material")
    end,
  },
}
