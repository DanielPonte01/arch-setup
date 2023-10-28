
local config = function()
	require("nvim-web-devicons").setup{
		override_by_extension = {
			["txt"] = {
				icon = "",
				-- name = "Text file"
			}
		}
	}
end

return config
