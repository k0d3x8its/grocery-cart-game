extends Node

signal score_changed(new_score)
signal game_ended

var score := 0
var playing := true

func reset():
	score = 0
	playing = true
	emit_signal("score_changed", score)

func add_score(n:int):
	if not playing: return
	score += n
	emit_signal("score_changed", score)

func game_over() -> void:
	if not playing: return
	playing = false
	emit_signal("game_ended")
