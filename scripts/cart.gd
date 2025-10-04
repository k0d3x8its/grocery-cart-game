extends CharacterBody2D

@export var speed := 1200.0
var drag_active := false
var drag_offset := Vector2.ZERO

func _ready() -> void:
	Global.game_ended.connect(_on_game_ended)

func _unhandled_input(event):
	if not Global.playing:
		return
	if event is InputEventScreenTouch:
		drag_active = event.pressed
		if event.pressed: drag_offset = global_position - event.position
	elif event is InputEventScreenDrag and drag_active:
		global_position.x = (event.position + drag_offset).x
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		drag_active = event.pressed
		if event.pressed: drag_offset = global_position - event.position
	elif event is InputEventMouseMotion and drag_active:
		global_position.x = (event.position + drag_offset).x

func _physics_process(_d):
	if not Global.playing:
		velocity.x = 0.0
		return
	var dir := 0.0
	if Input.is_action_pressed("move_left"):  dir -= 1.0
	if Input.is_action_pressed("move_right"): dir += 1.0
	velocity.x = dir * speed
	if dir != 0.0: move_and_slide()

	var vw := get_viewport_rect().size.x
	global_position.x = clamp(global_position.x, 60.0, vw - 60.0)

func _on_catch_zone_area_entered(area: Area2D) -> void:
	if area.is_in_group("item"):
		Global.add_score(1)
		area.queue_free()
	elif area.is_in_group("mascot"):
		Global.game_over()
		
func _on_game_ended() -> void:
	drag_active = false
	velocity = Vector2.ZERO
