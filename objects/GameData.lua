-- Handles all local data, as well as relevant serialization and de-serialization
GameData = {}
		
function saveGameData()
	bitser.dumpLoveFile("game_data", GameData)
end

function loadGameData()
	if love.filesystem.getRealDirectory("game_data") ~= nil then
		GameData = bitser.loadLoveFile("game_data")
	else
		GameData.high_score = 0
		GameData.sp = 0
		GameData.bought_node_indexes = {1}
	end
GameData.last_selected_ship = "Fighter"
end


--for i = 2, 892 do
--	if not (i >= 9 and i <= 11) then
--		table.insert(GameData.bought_node_indexes, i)
--	end
--end