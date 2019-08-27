SkillTree = Object:extend()

--[[
	TO-DO FOR EXERCISE 225:
	- Clicking on nodes SELECTS them, taking skill points away, but not actually buying them. DONE!
	- Pre-buying a node lights it up, but not the line. DONE!
	- Having at least 1 tentative bought node brings up the Apply Points/Cancel button. DONE!
	- Hovering over the buttons highlights them with a white outline. DONE!
	- Cancel refunds all spend skill points and un-highlights all the pre-bought nodes. DONE!
	- Buying officially spends skill points and lights up the lines. DONE!
]]--

function SkillTree:new()
	self.timer = Timer()
	self.main_canvas = love.graphics.newCanvas(gw, gh)
	camera = Camera(0, 0)
	camera.smoother = Camera.smooth.damped(5)
	self.font = fonts.m5x7_16

	selected_node_indexes = {}
	bought_node_indexes = {1}
	selected_sp = 0

	self.tree = table.copy(tree)
	for id, node in ipairs(self.tree) do
		--[[
			A note if you're on this section:
			The author adds the id's of the linked nodes directly to the node's table.
			I've elected to add the id's of the linked nodes to the links list just for clarity.
		]]--
		for _, linked_node_id in ipairs(node.links or {}) do
			table.insert(self.tree[linked_node_id].links, id)
		end
	end

	for id, node in ipairs(self.tree) do
		if node.links then
			node.links = M.unique(node.links)
		end
	end

	self.nodes = {}
	self.lines = {}

	local apply_points_txt = "Apply Points"
	local button_x, button_y = gw/2 - (16 + self.font:getWidth(apply_points_txt)) - 16, gh - self.font:getHeight() - 10
	local button_w, button_h = 16 + self.font:getWidth(apply_points_txt), self.font:getHeight() + 4
	local apply_points_button = Button(button_x, button_y, {w = button_w, h = button_h, text = apply_points_txt, font = self.font, center_justified = true, click = SkillTree.buySelectedNodes, click_args = self})
	local cancel_points_txt = "Cancel"
	button_x = gw/2 + 16
	local cancel_points_button = Button(button_x, button_y, {w = button_w, h = button_h, text = cancel_points_txt, font = self.font, center_justified = true, click = SkillTree.cancelSelectedNodes, click_args = self})
	self.select_nodes_buttons = {apply_points_button, cancel_points_button}

	for id, node in ipairs(self.tree) do table.insert(self.nodes, Node(id, node.x, node.y, node.cost, {no_description = node.no_description})) end
	for id, node in ipairs(self.tree) do 
		for _, linked_node_id in ipairs(node.links or {}) do
			table.insert(self.lines, Line(id, linked_node_id))
		end
	end
end

function SkillTree:update(dt)
	--[[
		Important note to make if you're on this section:
		LOVE 11.0 changed the way that love.keyboard.isDown() and love.mouse.isDown() work, which causes the boipushy input library to break if you try and bind
		mouse1 to left_click. It'll complain that mouse1 isn't a valid key constant, because the way the input library works is that it checks for a boolean value
		from love.keyboard.isDown() and love.mouse.isDown() in order to determine whether or not the input is down. Since mouse1 isn't a valid key constant for the keyboard,
		this throws an exception instead.
		
		You can modify your boipushy source code to use this commit: https://github.com/adnzzzzZ/boipushy/pull/29/commits/f7da44d6063ef2ffab6dde93051c9c958d67a00f
		since it doesn't seem like the author hasn't noticed yet and thus has not yet merged it in.
	]]--

	for _, node in ipairs(self.nodes) do
		node:update()
	end

	for _, line in ipairs(self.lines) do
		line:update()
	end

	if #selected_node_indexes > 0 then
		for _, select_node_button in ipairs(self.select_nodes_buttons) do
			select_node_button:update()
		end
	end

	if input:down('left_click') then
		local mx, my = camera:getMousePosition(sx, sy, 0, 0, sx*gw, sy*gh)
		local dx, dy = mx - self.previous_mx, my - self.previous_my
		camera:move(-dx, -dy)
	end
	self.previous_mx, self.previous_my = camera:getMousePosition(sx, sy, 0, 0, sx*gw, sy*gh)

	-- Added some simple limits for the zooming in/out.
	if input:pressed('zoom_in') then 
		local new_scale = camera.scale + 0.4
		if new_scale > 3 then new_scale = 3 end
		self.timer:tween('zoom', 0.2, camera, {scale = new_scale}, 'in-out-cubic') 
	end
	if input:pressed('zoom_out') then 
		local new_scale = camera.scale - 0.4
		if new_scale < 0.5 then new_scale = 0.5 end
		self.timer:tween('zoom', 0.2, camera, {scale = new_scale}, 'in-out-cubic') 
	end

	self.timer:update(dt)
end

function SkillTree:draw()
	love.graphics.setCanvas(self.main_canvas)
	love.graphics.clear()
	camera:attach(0, 0, gw, gh)
	for _, line in ipairs(self.lines) do
		line:draw()
	end
	for _, node in ipairs(self.nodes) do
		node:draw()
	end

	camera:detach()
	love.graphics.setBackgroundColor(0.04, 0.04, 0.04)
	-- Stats rectangle
	for _, node in ipairs(self.nodes) do
		if node.hot then
			local title = self.tree[node.id].title or ""
			local stats = self.tree[node.id].stats or {}
			-- Figure out max_text_width to be able to set the proper rectangle width
			local max_text_width = 0
			if self.font:getWidth(title) > max_text_width then max_text_width = self.font:getWidth(title) end
			for i = 1, #stats, 3 do
				if self.font:getWidth(stats[i]) > max_text_width then
					max_text_width = self.font:getWidth(stats[i])
				end
			end

			-- Draw rectangle
			local mx, my = love.mouse.getPosition() 
			mx, my = mx/sx, my/sy
			love.graphics.setColor(0, 0, 0, 222/255)
			love.graphics.rectangle('fill', mx, my, 16 + max_text_width, 
				self.font:getHeight() + (1 + #stats/3)*self.font:getHeight())  

			-- Draw text
			love.graphics.setColor(default_color)
			love.graphics.print(title, math.floor(mx + 8), math.floor(my + 2))
			for i = 1, #stats, 3 do
				love.graphics.print(stats[i], math.floor(mx + 8), 
					math.floor(my + self.font:getHeight()/2 + (1 + math.floor(i/3))*self.font:getHeight()))
			end
			love.graphics.setColor(skill_point_color)
			local sp_cost_txt = "COST: " .. (self.tree[node.id].cost or 0) .. "SP"
			love.graphics.print(sp_cost_txt, math.floor(mx + 8 + max_text_width - self.font:getWidth(sp_cost_txt)),  math.floor(my + 2))
		end
	end

	-- Player's SP
	love.graphics.setColor(skill_point_color)
	love.graphics.print(sp .. " SKILL POINTS", 12, self.font:getHeight() / 2)

	-- Player's Active Nodes
	local active_nodes_txt = #bought_node_indexes .. " / " .. max_nodes .. " ACTIVE NODES"
	love.graphics.print(active_nodes_txt, gw - self.font:getWidth(active_nodes_txt) - 12, self.font:getHeight() / 2)

	-- If player has selected any nodes, display Apply Points and Cancel button
	if #selected_node_indexes > 0 then
		for _, select_node_button in ipairs(self.select_nodes_buttons) do
			select_node_button:draw()
		end
	end
	love.graphics.setCanvas()

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setBlendMode('alpha', 'premultiplied')
	love.graphics.draw(self.main_canvas, 0, 0, 0, sx, sy)
	love.graphics.setBlendMode('alpha')

	love.graphics.setFont(self.font)
end

function SkillTree:finish()
	timer:after(1, function()
			gotoRoom('SkillTree')
		end)
end

function SkillTree:canNodeBeBought(id)
	-- You'll need to access the linked_node_id's from the node's links table if you've been adding id's to the links table.
	for _, linked_node_id in ipairs(self.tree[id].links or {}) do
		local enoughSP = sp - self.tree[id].cost >= 0
		if (M.any(bought_node_indexes, linked_node_id) or M.any(selected_node_indexes, linked_node_id)) and enoughSP then return true end
	end
end

function SkillTree:buySelectedNodes()
	bought_node_indexes = M.interleave(bought_node_indexes, selected_node_indexes)
	selected_sp = 0
	selected_node_indexes = {}
end

function SkillTree:cancelSelectedNodes()
	local selected_nodes = M.select(self.nodes, function(node, _)
			return node.selected
		end)
	M.invoke(selected_nodes, function(node, _)
			node.selected = false
		end)
	sp = sp + selected_sp
	selected_sp = 0
	selected_node_indexes = {}
end

function SkillTree:destroy()
end