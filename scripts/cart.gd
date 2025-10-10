extends CharacterBody2D

# ─────────────────────────────────────────────────────────────────────────────
# CART: movement + input + catch handling
# ─────────────────────────────────────────────────────────────────────────────

@export var speed := 1200.0
@export var screen_padding_left := 0.0
@export var screen_padding_right := 0.0

var drag_active: bool = false
var drag_offset: Vector2 = Vector2.ZERO

# ─────────────────────────────────────────────────────────────────────────────
# READY / SIGNALS
# ─────────────────────────────────────────────────────────────────────────────
func _ready() -> void:
	Global.game_ended.connect(_on_game_ended)

# ─────────────────────────────────────────────────────────────────────────────
# INPUT (touch + mouse drag)
# ─────────────────────────────────────────────────────────────────────────────
func _unhandled_input(event) -> void:
	if not Global.playing:
		return
		
	if event is InputEventScreenTouch:
		drag_active = event.pressed
		if event.pressed: drag_offset = global_position - event.position
		
	elif event is InputEventScreenDrag and drag_active:
		global_position.x = (event.position + drag_offset).x
		_keep_on_screen()
		
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		drag_active = event.pressed
		if event.pressed: drag_offset = global_position - event.position
		
	elif event is InputEventMouseMotion and drag_active:
		global_position.x = (event.position + drag_offset).x
		_keep_on_screen()

# ─────────────────────────────────────────────────────────────────────────────
# PHYSICS: keyboard movement
# ─────────────────────────────────────────────────────────────────────────────
func _physics_process(_delta_seconds: float) -> void:
	if not Global.playing:
		velocity.x = 0.0
		return
		
	var input_direction: float = 0.0
	if Input.is_action_pressed("move_left"):  input_direction -= 1.0
	if Input.is_action_pressed("move_right"): input_direction += 1.0
	
	velocity.x = input_direction * speed
	
	if input_direction != 0.0: 
		move_and_slide()
		_keep_on_screen()

# ─────────────────────────────────────────────────────────────────────────────
# SCREEN CLAMP
# ─────────────────────────────────────────────────────────────────────────────
func _keep_on_screen() -> void:
	var viewport_width: float = get_viewport_rect().size.x
	var extents: Vector2 = _cart_extents_global()
	
	var min_x_allowed: float = extents.x + screen_padding_left
	var max_x_allowed: float = viewport_width - (extents.y + screen_padding_right)
	 
	global_position.x = clamp(global_position.x, min_x_allowed, max_x_allowed)

func _cart_extents_global() -> Vector2:
	# Return Vector2(left_extent, right_extent)
	if has_node("CollisionPolygon2D"):
		var polygon_node: CollisionPolygon2D = $CollisionPolygon2D
		var local_polygon: PackedVector2Array = polygon_node.polygon
		if not local_polygon.is_empty():
			var min_global_x := INF
			var max_global_x := -INF
			var poly_global_transform: Transform2D = polygon_node.global_transform
			
			for local_vertex: Vector2 in local_polygon:
				var global_vertex: Vector2 = poly_global_transform * local_vertex
				min_global_x = min(min_global_x, global_vertex.x)
				max_global_x = max(max_global_x, global_vertex.x)
			
			var cart_center_x: float = global_position.x
			var left_extent: float = max(0.0, cart_center_x - min_global_x)
			var right_extent: float = max(0.0, max_global_x - cart_center_x)
			return Vector2(left_extent, right_extent)
		
	# Fallback if polygon is missing
	if $Sprite2D and $Sprite2D.texture:
		var sprite_half_width: float = $Sprite2D.texture.get_size().x * abs($Sprite2D.scale.x) * 0.5
		return Vector2(sprite_half_width, sprite_half_width)
	return Vector2.ZERO

# ─────────────────────────────────────────────────────────────────────────────
# CATCH ZONE HANDLER
# -----------------------------------------------------------------------------
# - Uses item.get_score_on_catch() so per-item multipliers are respected
# - Adds to Global score
# - Spawns a green pop-up above the cart
# ─────────────────────────────────────────────────────────────────────────────
func _on_catch_zone_area_entered(entered_area: Area2D) -> void:
	if not Global.playing:
		return

	if entered_area.is_in_group("item"):
		var score_change_from_catch: int = 1
		if entered_area.has_method("get_score_on_catch"):
			score_change_from_catch = entered_area.get_score_on_catch()
		
		# Update score first (keeps HUD consistent)
		Global.add_score(score_change_from_catch)
		
		# Score pops above cart
		UIEffect.spawn_score_popup(global_position, score_change_from_catch, UIEffect.cart_world_offset)
		
		# Cleanup item
		entered_area.queue_free()
		
	elif entered_area.is_in_group("mascot"):
		Global.game_over()

# ─────────────────────────────────────────────────────────────────────────────
# GAME ENDED
# ─────────────────────────────────────────────────────────────────────────────
func _on_game_ended() -> void:
	drag_active = false
	velocity = Vector2.ZERO
