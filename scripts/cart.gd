extends CharacterBody2D

@export var speed := 1200.0
@export var edge_padding_pixels: float = 50.0

var drag_active: bool = false
var drag_offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	Global.game_ended.connect(_on_game_ended)

func _unhandled_input(event) -> void:
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

func _physics_process(_delta_seconds: float) -> void:
	if not Global.playing:
		velocity.x = 0.0
		return
		
	var input_direction: float = 0.0
	if Input.is_action_pressed("move_left"):  input_direction -= 1.0
	if Input.is_action_pressed("move_right"): input_direction += 1.0
	
	velocity.x = input_direction * speed
	if input_direction != 0.0: move_and_slide()

	var viewport_width: float = get_viewport_rect().size.x
	global_position.x = clamp(global_position.x, edge_padding_pixels, viewport_width - edge_padding_pixels)

func _on_catch_zone_area_entered(entered_area: Area2D) -> void:
	if not Global.playing:
		return

	if entered_area.is_in_group("item"):
		var score_change_from_catch: int = 1
		if entered_area.has_method("get_score_on_catch"):
			score_change_from_catch = entered_area.get_score_on_catch()
		Global.add_score(score_change_from_catch)
		entered_area.queue_free()
	elif entered_area.is_in_group("mascot"):
		Global.game_over()
		
func _on_game_ended() -> void:
	drag_active = false
	velocity = Vector2.ZERO
