extends Node

# Game State
var score: int = 0
var high_score: int = 0
var current_level: int = 1
var timer_duration: int = 45
var player_name: String = "Player"

# Score history
var scores: Array = []

func _ready():
	load_game_data()

func add_score(points: int):
	score += points

func reset_score():
	score = 0

func save_score(name: String, final_score: int) -> bool:
	var is_new_high_score = final_score > high_score
	
	if is_new_high_score:
		high_score = final_score
	
	player_name = name
	
	# Add to scores list
	scores.append({
		"playerName": name,
		"score": final_score,
		"timestamp": Time.get_datetime_string_from_system()
	})
	
	# Sort by score descending
	scores.sort_custom(func(a, b): return a.score > b.score)
	
	# Keep only top 10
	if scores.size() > 10:
		scores.resize(10)
	
	save_game_data()
	return is_new_high_score

func get_top_scores(limit: int = 5) -> Array:
	return scores.slice(0, mini(limit, scores.size()))

func save_game_data():
	var save_data = {
		"high_score": high_score,
		"player_name": player_name,
		"scores": scores
	}
	
	var file = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()

func load_game_data():
	if FileAccess.file_exists("user://savegame.save"):
		var file = FileAccess.open("user://savegame.save", FileAccess.READ)
		if file:
			var json = JSON.new()
			var parse_result = json.parse(file.get_as_text())
			file.close()
			
			if parse_result == OK:
				var data = json.data
				high_score = data.get("high_score", 0)
				player_name = data.get("player_name", "Player")
				scores = data.get("scores", [])