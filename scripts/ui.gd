extends CanvasLayer
@onready var score_label := $ScoreLabel

func _ready():
	# Listen for score changes
	Global.connect("score_changed", _on_score_changed)
	# Initialize label with current score
	_on_score_changed(Global.score)

func _on_score_changed(s):
	score_label.text = "Score: %s" % s
