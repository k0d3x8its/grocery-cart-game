extends CanvasLayer

# ─────────────────────────────────────────────────────────────────────────────
# UIEffect
# -----------------------------------------------------------------------------
# Purpose:
#   - Spawns FloatingScore UI pop-ups in SCREEN space
#   - Converts WORLD → SCREEN once at spawn, so pop-ups do not follow movement
#
# Public API:
#   spawn_score_popup(world_pos, amount, extra_world_offset := Vector2.ZERO)
#   spawn_score_popup_above_cart(amount)
#
# Editor step:
#   - Put your Cart node in the 'player' group so it can be found
# ─────────────────────────────────────────────────────────────────────────────

const FLOATING_SCORE := preload("res://scenes/floatingScore.tscn")

# Consistent colors by sign
const POSITIVE_COLOR := Color(0.30, 1.00, 0.55)			# Green
const NEGATIVE_COLOR := Color(1.00, 0.35, 0.35)			# Red

# WORLD-space offsets applied before converting to screen
@export var cart_world_offset := Vector2(0, -48)
@export var item_world_offset := Vector2(0, -32)

# ─────────────────────────────────────────────────────────────────────────────
# PUBLIC API
# ─────────────────────────────────────────────────────────────────────────────

# Generic spawner at any WORLD position (e.g. above a missing item)
func spawn_score_popup(world_pos: Vector2, amount: int, extra_world_offset: Vector2 = Vector2.ZERO) -> void:
	var node: Control = _instance_floating_score()
	if node == null:
		return
	
	# Children of CanvasLayer render in SCREEN space
	add_child(node)
	
	# Convert WORLD -> SCREEN exactly once (pop-up won't follow)
	var screen_pos := _world_to_screen(world_pos + extra_world_offset)
	
	# Build display text and choose color by signer
	var sign_str := "+" if amount >= 0 else ""
	var col := POSITIVE_COLOR if amount >= 0 else NEGATIVE_COLOR
	
	# Defer until node is full ready on the tree
	node.call_deferred("show_value", screen_pos, "%s%d" % [sign_str, amount], col)



# ─────────────────────────────────────────────────────────────────────────────
# INTERNAL HELPERS
# ─────────────────────────────────────────────────────────────────────────────

func _instance_floating_score() -> Control:
	if FLOATING_SCORE == null:
		push_error("UIEffect: floatingScore.tscn missing.")
		return null
	
	var node := FLOATING_SCORE.instantiate()
	if node == null:
		push_error("UIeffect: failed to instantiate floatingScore.")
		return null
	
	return node

func _world_to_screen(world_pos: Vector2) -> Vector2:
	var cam := get_viewport().get_camera_2d()
	if cam == null:
		# Fallback if no Camera2D exists
		return world_pos
	return cam.project_position(world_pos)

func _find_cart() -> Node2D:
	var node := get_tree().get_first_node_in_group("player")
	return node if node is Node2D else null
