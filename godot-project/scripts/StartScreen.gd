extends Control

@onready var high_score_label: Label = $VBoxContainer/HighScorePanel/HighScoreLabel
@onready var player_name_input: LineEdit = $VBoxContainer/PlayerNameInput
@onready var top_scores_container: VBoxContainer = $VBoxContainer/TopScoresPanel/TopScoresList
@onready var start_button: Button = $VBoxContainer/ButtonContainer/StartButton
@onready var close_button: Button = $VBoxContainer/ButtonContainer/CloseButton

func _ready():
	# Connect button signals
	start_button.pressed.connect(_on_start_pressed)
	close_button.pressed.connect(_on_close_pressed)
	
	# Initialize high score display to 0
	high_score_label.text = "High Score: 0"
	
	# Load saved data
	_load_saved_data()

func _load_saved_data():
	# Update high score display
	high_score_label.text = "High Score: %d" % Global.high_score
	
	# Pre-fill player name
	if Global.player_name != "":
		player_name_input.text = Global.player_name
	
	# Display top scores
	_display_top_scores()

func _display_top_scores():
	# Clear existing entries
	for child in top_scores_container.get_children():
		child.queue_free()
	
	var top_scores = Global.get_top_scores(5)
	
	if top_scores.size() == 0:
		var no_scores_label = Label.new()
		no_scores_label.text = "No scores yet!"
		no_scores_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
		top_scores_container.add_child(no_scores_label)
		return
	
	for i in range(top_scores.size()):
		var entry = top_scores[i]
		var score_label = Label.new()
		score_label.text = "%d. %s - %d" % [i + 1, entry.playerName, entry.score]
		score_label.add_theme_color_override("font_color", Color(1, 0.84, 0))
		top_scores_container.add_child(score_label)

func _on_start_pressed():
	# Save player name
	var name = player_name_input.text.strip_edges()
	if name == "":
		name = "Player"
	Global.player_name = name
	Global.reset_score()
	
	# Change to main game scene
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_close_pressed():
	get_tree().quit()