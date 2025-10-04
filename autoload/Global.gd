extends Node

# Emitted whenever score changes
signal score_changed(new_score: int)
# Emitted once when the round ends (mascot caught)
signal game_ended

# Current round score
var score := 0
# Whether gameplay is active
var playing: bool = true

# Reset round state and broacast the fresh score (0)
func reset():
	score = 0
	playing = true
	emit_signal("score_changed", score)

# Add to the score only if the round is active
func add_score(points_to_add: int) -> void:
	if not playing: return
	score += points_to_add
	emit_signal("score_changed", score)

# End the round exactly once; does nothing if already ended
func game_over() -> void:
	if not playing: return
	playing = false
	emit_signal("game_ended")
