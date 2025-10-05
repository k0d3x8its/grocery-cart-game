extends CanvasLayer

# ─────────────────────────────────────────────────────────────────────────────
# NODE REFERENCES
# ─────────────────────────────────────────────────────────────────────────────
@onready var score_label: Label = $ScoreLabel
@onready var panel: PanelContainer = $GameOverPanel
@onready var final_score: Label = $GameOverPanel/VBox/FinalScore
@onready var restart_btn: Button = $GameOverPanel/VBox/Restart
@onready var quit_btn: Button = $GameOverPanel/VBox/Quit

func _ready() -> void:
	# UI should still work while the game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Start state
	_update_hud_score(Global.score)
	# Panel hidden until mascot is caught
	panel.visible = false
	
	# Listen for score updates and game over
	Global.score_changed.connect(_on_score_changed)
	Global.game_ended.connect(_on_game_over)

# ─────────────────────────────────────────────────────────────────────────────
# SCORE UPDATES (HUD during gameplay)
# ─────────────────────────────────────────────────────────────────────────────

# Add commas to make numbers easier to read
func format_with_commas(value: int) -> String:
	# Preserve negative sign if needed
	var sign_prefix := "-" if value < 0 else ""
	# Convert absolute value to string
	var digits := str(abs(value))
	# Placement for final output
	var result := ""
	# Track how many digits are left to process
	var remaining_length := digits.length()
	
	# Insert commas every 3 digits from the right
	while remaining_length > 3:
		result = "," + digits.substr(remaining_length - 3, 3) + result
		remaining_length -= 3
		
	# Add whatever digits remain at the front (no comma)
	result = digits.substr(0, remaining_length) + result
	
	return sign_prefix + result

# Called when Global emits "score_changed(new_score)"
func _on_score_changed(new_score: int) -> void:
	_update_hud_score(new_score)

# Update only the HUD label (top-left) during gameplay
func _update_hud_score(new_score: int) -> void:
	var formatted_score := format_with_commas(new_score)
	score_label.text = "Score: " + formatted_score

# ─────────────────────────────────────────────────────────────────────────────
# GAME OVER FLOW
# ─────────────────────────────────────────────────────────────────────────────

# Called when Global emits "game_ended"
func _on_game_over() -> void:
	# Freeze gameplay
	get_tree().paused = true
	
	# Hide the HUD score so it does not show in top-left corner
	score_label.visible = false
	
	# Show the final score inside the panel and reveal the panel
	final_score.text = "Score: " + format_with_commas(Global.score)
	panel.visible = true

# ─────────────────────────────────────────────────────────────────────────────
# BUTTON HANDLERS
# ─────────────────────────────────────────────────────────────────────────────

# Restart: unpause, reset global state, and reload the current scene (game.tscn)
func _on_restart_pressed() -> void:
	get_tree().paused = false
	Global.reset()
	get_tree().reload_current_scene()

# Quit the application immediately
func _on_quit_pressed() -> void:
	get_tree().quit()
