extends Area2D
@export var fall_speed := 500.0

func _process(delta: float) -> void:
	if not Global.playing:
		return
	position.y += fall_speed * delta
	
	if position.y > get_viewport_rect().size.y + 100.0:
		queue_free()
