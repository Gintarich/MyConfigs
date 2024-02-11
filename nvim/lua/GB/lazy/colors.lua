return {
    'morhetz/gruvbox',
    config = function()
        vim.cmd.colorscheme("gruvbox")
    end
    --    "bartekprtc/gruv-vsassist.nvim",
    --    config = function()
    --        require("gruv-vsassist").setup({
    --            -- Enable transparent background
    --            transparent = false,
    --
    --            -- Enable italic comment
    --            italic_comments = true,
    --
    --            -- Disable nvim-tree background color
    --            disable_nvimtree_bg = true,
    --
    --            -- Override colors (see ./lua/gruv-vsassist/colors.lua)
    --            color_overrides = {
    --                vscLineNumber = '#FFFFFF',
    --            },
    --        })
    --    end
}
