extends Area2D

@export var fall_speed := 450.0

func _physics_process(delta: float) -> void:
	if not Global.playing:
		return
	position.y += fall_speed * delta

	# Safety if it escapes
	if position.y > get_viewport_rect().size.y + 200.0:
		queue_free()
