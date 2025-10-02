extends Control
@export var game_scene: PackedScene

func _ready() -> void:
	if game_scene == null:
		game_scene = load("res://scenes/game.tscn")

func _on_start_game_pressed() -> void:
	# Reset score
	Global.reset()
	# load game
	get_tree().change_scene_to_packed(game_scene)

func _on_quit_pressed() -> void:
	# Quit game
	get_tree().quit()
