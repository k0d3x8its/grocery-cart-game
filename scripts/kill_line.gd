extends Area2D

@export var fallback_miss_points: int = -1
@export var horizontal_padding_pixels: float = 64
@export var bottom_offset_pixels: float = 8

func _ready() -> void:
	# Auto-fit width and place at the bottom of the visible area
	var visible_rect: Rect2 = get_viewport().get_visible_rect()
	position = Vector2(
		visible_rect.position.x + visible_rect.size.x / 2.0,
		visible_rect.position.y + visible_rect.size.y + bottom_offset_pixels
	)
	
	# Explicit cast to RectangleShape2D so GDScript is happy
	var rect_shape: RectangleShape2D = ($CollisionShape2D.shape as RectangleShape2D)
	if rect_shape:
		rect_shape.size.x = visible_rect.size.x + horizontal_padding_pixels

func _on_killLine_area_entered(entered_area: Area2D) -> void:
	_handle_object_entered(entered_area)

func _on_killLine_body_entered(entered_body: Node) -> void:
	_handle_object_entered(entered_body)
	
func _handle_object_entered(entered_node: Node) -> void:
	if not is_instance_valid(entered_node):
		return
	# Always clean up the fallen object (deferred = safe during signals)
	entered_node.call_deferred("queue_free")
	
	# No scoring after game ended
	if not Global.playing:
		return
	
	# Ignore mascot misses (no penalty)
	if entered_node.is_in_group("mascot"):
		return
	
	# Miss logic for normal items
	if entered_node.is_in_group("item"):
		var score_change_from_miss: int = _get_points_for_miss(entered_node)
		Global.add_score(score_change_from_miss)
		
		# Instant game over if score dips below zero
		if Global.score < 0:
			Global.game_over()

func _get_points_for_miss(item_node: Node) -> int:
	if item_node.has_method("get_score_on_miss"):
		return item_node.get_score_on_miss()
	return fallback_miss_points
