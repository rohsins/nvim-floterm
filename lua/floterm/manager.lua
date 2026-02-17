local M = {}

local state = {
	terminals = {},
	last_id = 0,
	current_id = nil,
}

local function create_floating_window(opts)
	opts = opts or {}
	local width = opts.width or math.floor(vim.o.columns * 0.8)
	local height = opts.height or math.floor(vim.o.lines * 0.8)

	local col = math.floor((vim.o.columns - width) / 2)
	local row = math.floor((vim.o.lines - height) / 2)

	local buf
	if opts.buf and vim.api.nvim_buf_is_valid(opts.buf) then
		buf = opts.buf
	else
		buf = vim.api.nvim_create_buf(false, true)
	end

	local win_config = {
		relative = "editor",
		width = width,
		height = height,
		col = col,
		row = row,
		style = "minimal",
		border = "rounded",
		title = opts.title or " Terminal ",
		title_pos = "center",
	}

	local win = vim.api.nvim_open_win(buf, true, win_config)
	return { buf = buf, win = win }
end

function M.new_terminal()
	if state.last_id ~= 0 and vim.api.nvim_win_is_valid(state.terminals[state.last_id].win) then
		vim.api.nvim_win_hide(state.terminals[state.last_id].win)
	end

	state.last_id = state.last_id + 1
	local id = state.last_id

	local term = create_floating_window { title = " Terminal " .. id .. " " }
	vim.cmd("terminal")
	vim.cmd("startinsert")

	term.id = id
	state.terminals[id] = term
	state.current_id = id
	return term
end

function M.toggle_terminal(id, from_ui)
	if not from_ui then from_ui = false end
	if not id then id = state.current_id or state.last_id end
	local term = state.terminals[id]

	if term and not vim.api.nvim_buf_is_valid(term.buf) then
		id = M.list_terminals()[1]
		term = state.terminals[id]

		if id == nil then
			state.current_id = nil
			state.last_id = 0
		end
	end

	if not term then
		term = M.new_terminal()
	elseif vim.api.nvim_win_is_valid(term.win) and id == state.current_id and not from_ui then
		vim.api.nvim_win_hide(term.win)
	elseif vim.api.nvim_win_is_valid(term.win) and id == state.current_id and from_ui then
	else
		if vim.api.nvim_win_is_valid(state.terminals[state.current_id].win) then
			vim.api.nvim_win_hide(state.terminals[state.current_id].win)
		end

		term = create_floating_window {
			buf = term.buf,
			title = " Terminal " .. id .. " "
		}
		state.terminals[id].win = term.win
		state.current_id = id
		vim.cmd("startinsert")
	end
end

function M.list_terminals()
	local ids = {}
	for id, term in pairs(state.terminals) do
		if vim.api.nvim_buf_is_valid(term.buf) then
			table.insert(ids, id)
		end
	end
	table.sort(ids)
	return ids
end

function M.select_terminal()
	local ids = M.list_terminals()
	if #ids == 0 then
		vim.notify("No terminals available", vim.log.levels.INFO)
		return
	end

	local items = {}
	for _, id in ipairs(ids) do
		table.insert(items, "Terminal " .. id)
	end

	vim.ui.select(items, { prompt = "Select terminal:" }, function(choice)
		if choice then
			local id = tonumber(choice:match("%d+"))
			M.toggle_terminal(id, true)
		end
	end)
end

function M.next_terminal()
	local ids = M.list_terminals()
	print(ids)
	if #ids == 1 then
		return
	end
	if #ids == 0 then
		vim.notify("No terminals available", vim.log.levels.INFO)
		return
	end
	local idx = vim.fn.index(ids, state.current_id) or -1
	local next_idx = (idx + 1) % #ids + 1
	M.toggle_terminal(ids[next_idx])
end

function M.prev_terminal()
	local ids = M.list_terminals()
	print(ids)
	if #ids == 1 then
		return
	end
	if #ids == 0 then
		vim.notify("No terminals available", vim.log.levels.INFO)
		return
	end
	local idx = vim.fn.index(ids, state.current_id) or -1
	local prev_idx = (idx - 1 + #ids) % #ids + 1
	M.toggle_terminal(ids[prev_idx])
end

function M.statusline()
	local ids = M.list_terminals()
	if #ids == 0 then
		return ""
	end

	local parts = {}
	for _, id in ipairs(ids) do
		if id == state.current_id then
			table.insert(parts, "%#FlotermActive#T" .. id .. "%*")
		else
			table.insert(parts, "%#FlotermInactive#T" .. id .. "%*")
		end
	end

	return table.concat(parts, " ")
end

return M

