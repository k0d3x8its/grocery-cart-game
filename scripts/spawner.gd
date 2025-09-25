# Purpose: Continuously spawn falling objects (items/mascot) with good spacing,
#          on-screen safety, and a gentle difficulty ramp.

extends Node2D

# ─────────────────────────────────────────────────────────────────────────────
# EXPORTED SETTINGS (tweakable in Inspector)
# ─────────────────────────────────────────────────────────────────────────────
# --- What to spawn ---
@export var item_scene: PackedScene				# assign items.tscn in the Inspector
@export var mascot_scene: PackedScene			# assign later, when mascot is created
@export var mascot_chance := 0.50				# 0.15 standard - increase for difficulty

# --- Spawn timing & speed ---
@export var spawn_interval_seconds := 0.5		# seconds between spawns
@export var item_fall_speed := 500.0			# base fall speed passed to items
@export var difficulty_tick_seconds := 10.0		# every N seconds, makes it harder

# --- Horizontal placement and spacing ---
@export var x_edge_margin := 20.0				# keep items inside screen edges
@export var x_min_gap_between_spawns := 150.0	# minimum distance between consecutive spawns 

# --- Per-istance variations ---
@export var random_rot_min_deg := -10.0			# per-item minimum rotation variance
@export var random_rot_max_deg := 10.0			# per-item maximum rotation variance
@export var random_scale_min := 0.9				# per-item minumum size variance
@export var random_scale_max := 1.1				# per-item maximum size variance 

# ─────────────────────────────────────────────────────────────────────────────
# RUNTIME STATE (private)
# ─────────────────────────────────────────────────────────────────────────────
var _spawn_timer := 0.0							# spawn timer
var _difficulty_timer := 0.0					# difficulty timer
var _last_x_pos := -INF							# remember last spawn position    

# ─────────────────────────────────────────────────────────────────────────────
# LIFECYCLE
# ─────────────────────────────────────────────────────────────────────────────
func _ready() -> void:
	randomize()  # makes randf_range different each run

func _process(delta: float) -> void:
	# Spawn timer
	if not Global.playing:
		return
	_spawn_timer += delta
	if _spawn_timer >= spawn_interval_seconds:
		_spawn_timer = 0.0
		_spawn_one()

	# Difficulty ramp
	_difficulty_timer += delta
	if _difficulty_timer >= difficulty_tick_seconds:
		_difficulty_timer = 0.0
		spawn_interval_seconds = max(0.4, spawn_interval_seconds - 0.05)
		item_fall_speed += 30.0

# ─────────────────────────────────────────────────────────────────────────────
# SPAWN HELPERS
# ─────────────────────────────────────────────────────────────────────────────
func _pick_spawn_x(viewport_width: float) -> float:
	# Try several times to find an x far enough from the last one.
	for i in range(8):
		var candidate_x := randf_range(x_edge_margin, viewport_width - x_edge_margin)
		if abs(candidate_x - _last_x_pos) >= x_min_gap_between_spawns:
			_last_x_pos = candidate_x
			return candidate_x
	# fallback if unlucky: accept whatever we got
	var fallback_x := randf_range(x_edge_margin, viewport_width - x_edge_margin)
	_last_x_pos = fallback_x
	return fallback_x

func _choose_spawn_scene() -> PackedScene:
	# Prefer mascot sometimes if assigned and the random roll says so; otherwise item.
	if item_scene == null and mascot_scene == null:
		push_warning("Spawner: assign item_scene (and mascot_scene if used).")
		return null
	var use_mascot := mascot_scene != null and randf() < mascot_chance
	return mascot_scene if use_mascot else item_scene

# ─────────────────────────────────────────────────────────────────────────────
# ░ MAIN SPAWN
# ─────────────────────────────────────────────────────────────────────────────
func _spawn_one() -> void:
	var scene := _choose_spawn_scene()
	if scene == null:
		return

	var node := scene.instantiate()

	# Per-item variation
	node.rotation_degrees = randf_range(random_rot_min_deg, random_rot_max_deg)
	var s := randf_range(random_scale_min, random_scale_max)
	# Scales visuals and collider together
	node.scale = Vector2(s, s)

	# Pass down fall speed exported from items.gd
	node.fall_speed = item_fall_speed
	
	# Add to Playfield (Spawner's parent) first so node.position is in parent's local space
	var parent := get_parent()
	parent.add_child(node)
	
	# Visible rect in global space
	var vr: Rect2i = get_viewport().get_visible_rect()
	
	# Screen viewport edges
	var viewport_left:  float = vr.position.x
	var viewport_right: float = vr.position.x + vr.size.x
	var viewport_top:   float = vr.position.y
	
	var spawn_x_rel : float = _pick_spawn_x(vr.size.x)

	# Derive half-width from CollisionPolygon2D (fallback 24 for 48px square)
	var approx_half_width: float = 24.0 * node.scale.x
	var cp := node.get_node_or_null("CollisionPolygon2D") as CollisionPolygon2D
	if cp and cp.polygon.size() > 0:
		var min_x: float = INF
		var max_x: float = -INF
		for p in cp.polygon:
			min_x = min(min_x, p.x)
			max_x = max(max_x, p.x)
		approx_half_width = ((max_x - min_x) * 0.5) * node.scale.x

	# Safe margin: keep away from edges 
	var safe_margin: float = max(x_edge_margin, approx_half_width + 4.0)

	# Clamp the global left/right bounds
	var spawn_x_global: float = clampf(
		viewport_left + spawn_x_rel,
		viewport_left + safe_margin,
		viewport_right - safe_margin
	)

	# position just above the visble top (global)
	node.global_position = Vector2(spawn_x_global, viewport_top - 50.0)
