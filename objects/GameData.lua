-- Handles all local data, as well as relevant serialization and de-serialization
GameData = {}
GameData.last_selected_ship = "Fighter"
GameData.high_score = 0

selected_node_indexes = {}
bought_node_indexes = {1}

--for i = 2, 892 do
--	if not (i >= 9 and i <= 11) then
--		table.insert(bought_node_indexes, i)
--	end
--end