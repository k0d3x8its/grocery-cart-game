extends Control

# ─────────────────────────────────────────────────────────────────────────────
# FloatingScore
# -----------------------------------------------------------------------------
# Purpose:
#	- Display a temorary score pop-up in SCREEN space
#	- Pops up, floats upward, fades out, and deletes itself
#	- Does not follow the cart or item after spawning 
# ─────────────────────────────────────────────────────────────────────────────

@onready var text_label: Label = $Text

# ─────────────────────────────────────────────────────────────────────────────
# CONFIGURABLE VALUES (tweak in Inspector)
# ─────────────────────────────────────────────────────────────────────────────
@export var rise_pixels := 300.0				# How far it floats up (screen px)
@export var duration := 2.25				# Time to fade out
@export var pop_scale := 1.15				# Inital overshoot scale

# ─────────────────────────────────────────────────────────────────────────────
# PUBLIC METHOD: show_value
# Called automatically by UIEffects after the pop-up is instantiated.
# Parameters:
#   screen_pos : Vector2 → where to display the pop-up
#   text       : String  → text to show (e.g. "+1", "-2", etc.)
#   color      : Color   → tint for the text (usually green for +, red for -)
# ─────────────────────────────────────────────────────────────────────────────
func show_value(screen_pos: Vector2, text: String, color: Color) -> void:
	# Initial visual setup ----------------------------------------------------
	position = screen_pos
	scale = Vector2(0.9, 0.9)
	modulate = Color(1,1,1,1)
	text_label.text = text
	text_label.self_modulate = color
	
	# ─────────────────────────────────────────────────────────────────────────
	# MAIN ANIMATION TWEEN (main_tween)
	# -------------------------------------------------------------------------
	# - Moves the pop-up upward
	# - Fades it out
	# - Scales up slightly for a "pop" feel
	# ─────────────────────────────────────────────────────────────────────────
	var main_tween := create_tween().set_parallel(true)
	
	# Move upward (in screen space)
	main_tween.tween_property(self, "position:y", position.y - rise_pixels, duration)
	
	# Fade out by decreasing alpha to 0
	main_tween.tween_property(self, "modulate:a", 0.0, duration)
	
	# Scale up with a slight "back" easing curve for a bounce feel
	main_tween.tween_property(self, "scale", Vector2(pop_scale, pop_scale), duration * 0.35)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
	
	# ─────────────────────────────────────────────────────────────────────────
	# SECONDARY TWEEN (settle_tween)
	# -------------------------------------------------------------------------
	# - Waits briefly (~35% of total duration)
	# - Then scales back to normal size for a smooth finish
	# ─────────────────────────────────────────────────────────────────────────
	await get_tree().create_timer(duration * 0.35).timeout
	var settle_tween := create_tween()
	settle_tween.tween_property(self, "scale", Vector2(1.0,1.0), duration * 0.35)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
	
	# ─────────────────────────────────────────────────────────────────────────
	# CLEANUP
	# -------------------------------------------------------------------------
	# Once the main tween finishes (movement + fade complete), remove the node
	# from the scene tree to avoid buildup of old UI nodes.
	# ─────────────────────────────────────────────────────────────────────────
	await main_tween.finished
	queue_free()
