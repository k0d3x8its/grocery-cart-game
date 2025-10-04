# Shared by all items

extends Area2D
@export var fall_speed := 500.0

# Normal item scoring (used when not a multiplier)
@export var points_on_catch: int = 1
@export var points_on_miss: int = -1

# Multiplier mode (if enabled: +multiplier_value on catch, -multiplier_value on miss)
@export var is_multiplier_item: bool = false
@export var multiplier_value: int = 1

func _ready() -> void:
	# Make sure KillLine filters normal items
	if not is_in_group("item"):
		add_to_group("item")

func _physics_process(delta_seconds: float) -> void:
	if not Global.playing:
		return
	position.y += fall_speed * delta_seconds
	
# ─────────────────────────────────────────────────────────────────────────────
# Scoring API (used by Cart on catch and KillLine on miss)
# ─────────────────────────────────────────────────────────────────────────────
func get_score_on_catch() -> int:
	if is_multiplier_item:
		return int(multiplier_value)
	return int(points_on_catch)
	
func get_score_on_miss() -> int:
	if is_multiplier_item:
		return -int(multiplier_value)
	return int(points_on_miss)
