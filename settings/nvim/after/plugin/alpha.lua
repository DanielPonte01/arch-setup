
local config = function()
	local colors = require("colors")
    local theme  = require("alpha.themes.theta")
    local header = require("plugins.configs.alpha.headers")["random"]
    local footer = require("plugins.configs.alpha.footers")["random"]

    local function create_gradient(start_color, mid_color, end_color, steps)
        local function get_color_component(color, index)
            return tonumber("0x" .. color:sub(index, index + 1))
        end

        local gradient = {}

        local half_steps = math.floor(steps / 2)
        for i = 1, half_steps do
            local r = start_color and get_color_component(start_color, 2) or 0
            local g = start_color and get_color_component(start_color, 4) or 0
            local b = start_color and get_color_component(start_color, 6) or 0
            r = r + (mid_color and get_color_component(mid_color, 2) - r) * (i - 1) / (half_steps - 1)
            g = g + (mid_color and get_color_component(mid_color, 4) - g) * (i - 1) / (half_steps - 1)
            b = b + (mid_color and get_color_component(mid_color, 6) - b) * (i - 1) / (half_steps - 1)
            table.insert(gradient, string.format("#%02x%02x%02x", math.floor(r), math.floor(g), math.floor(b)))
        end

        for i = half_steps + 1, steps do
            local r = mid_color and get_color_component(mid_color, 2) or 0
            local g = mid_color and get_color_component(mid_color, 4) or 0
            local b = mid_color and get_color_component(mid_color, 6) or 0
            r = r + (end_color and get_color_component(end_color, 2) - r) * (i - half_steps - 1) / (steps - half_steps - 1)
            g = g + (end_color and get_color_component(end_color, 4) - g) * (i - half_steps - 1) / (steps - half_steps - 1)
            b = b + (end_color and get_color_component(end_color, 6) - b) * (i - half_steps - 1) / (steps - half_steps - 1)
            table.insert(gradient, string.format("#%02x%02x%02x", math.floor(r), math.floor(g), math.floor(b)))
        end

        return gradient
    end

    local function apply_gradient(text, start_color, mid_color, end_color)
        local gradient = create_gradient(start_color, mid_color, end_color, 30)
        local lines = {}

        for i, line in ipairs(text) do
            local opts = { hl = "HeaderGradient" .. i, shrink_margin = true, position = "center" }
            table.insert(lines, { type = "text", val = line, opts = opts })
            vim.api.nvim_set_hl(0, opts.hl, { fg = gradient[i] })
        end

        return { type = "group", val = lines, opts = { position = "center" } }
    end

	local function get_info()
		local lazy_stats = require("lazy").stats()
		local total_plugins = "󰏔  " .. lazy_stats.loaded .. "/" .. lazy_stats.count .. " packages loaded"
		local datetime = os.date("  %A, %B, %d")
		local version = vim.version()
		local nvim_version_info = "  " .. version.major .. "." .. version.minor .. "." .. version.patch
		local info_string = datetime .. "  |  " .. total_plugins .. "  |  " .. nvim_version_info

		return {
			type = "text",
			val = info_string,
			opts = {
				hl = "Operator",
				position = "center",
			},
		}
	end

	local function pad_string(str, len, align)
		local str_len = #str
		if str_len >= len then
			return str
		end

		local pad_len = len - str_len
		local pad = string.rep(" ", pad_len)

		if align == "left" then
			return str .. pad
		elseif align == "right" then
			return pad .. str
		elseif align == "center" then
			local left_pad = math.floor(pad_len / 2)
			local right_pad = pad_len - left_pad
			return string.rep(" ", left_pad) .. str .. string.rep(" ", right_pad)
		end
	end


	local dashboard = require("alpha.themes.dashboard")
	local buttons_start = {
		type = "group",
		val = function()
			local btns = {
				dashboard.button("e", "  New Fie" , ":ene<BAR> startinsert<CR>"),
				dashboard.button("t", "  Open Terminal", "<cmd>ToggleTerm<CR>"),
				dashboard.button("o", "  Open File Manager", ":NeoTreeFocusToggle<CR>" ),
			}
			return {
				{ type = "text", val = "Actions", opts = { hl = "PreProc", position = "center" }},
				{ type = "group", val = btns, opts = { hl = "PreProc" } },
			}
		end
	}

	local buttons_mid = {
		type = "group",
		val = function ()
			local btns = {
				dashboard.button("l", "󰒓  Lazy", "<cmd>Lazy<CR>"),
				dashboard.button("m", "  Mason", "<cmd>Mason<CR>"),
				dashboard.button("p", "󰁨  LSP Info", "<cmd>LspInfo<CR>"),
			}
			return {
				{ type = "text", val = "Utils", opts = { hl = "PreProc", position = "center" }},
				{ type = "group", val = btns, opts = { hl = "PreProc" } },
			}
		end
	}

	local buttons_end = {
		type = "group",
		val = function ()
			local btns = {
				dashboard.button("q", "󰈆  Quit", ":qa<CR>"),
			}
			return {
				-- { type = "text", val = "Utils", opts = { hl = "PreProc", position = "center" }},
				{ type = "group", val = btns, opts = { hl = "PreProc" } },

			}
		end
	}

	local function get_mru(max_shown)
		local tbl = {
			{ type = "text", val = "Recent Files", opts = { hl = "@text.title", position = "center" } },
            { type = "padding", val = 1 },
		}

		local mru_list = theme.mru(1, "", max_shown)

		for _, file in ipairs(mru_list.val) do
			table.insert(tbl, file)
		end

		return { type = "group", val = tbl, opts = {} }
	end

	local function get_footer(width)
		local max_width = width or 35

		local tbl = {}
		for _, text in ipairs(footer) do
			table.insert(tbl, { type = "text", val = pad_string(text, max_width, "center"), opts = { hl = "SpecialComment", position = "center" } })
		end

		return {
			type = "group",
			val = tbl,
			opts = {},
		}
	end


	theme.config.layout = {
		{ type = "padding", val = 1 },
		apply_gradient(header, colors.HeaderGradient1, colors.HeaderGradient2, colors.HeaderGradient3),
		{ type = "padding", val = 1 },
        get_info(),
		{ type = "padding", val = 1 },
        buttons_start,
		{ type = "padding", val = 1 },
		buttons_mid,
		{ type = "padding", val = 1 },
		buttons_end,
		{ type = "padding", val = 1 },
        get_mru(),
		{ type = "padding", val = 3 },
        get_footer(),
	}
	require("alpha").setup(theme.config)
end

return config

