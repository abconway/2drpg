extends CharacterBody2D
class_name Player


@onready var animation_tree := $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")

const SPEED := 100


func _physics_process(delta: float) -> void:
	var direction := Vector2(
		Input.get_axis("player_move_left", "player_move_right"),
		Input.get_axis("player_move_up", "player_move_down"),
	)
	velocity = direction * SPEED
	set_blend_pos(direction)
	move_and_slide()


func set_blend_pos(p: Vector2) -> void:
	animation_tree.set("parameters/idle/blend_position", p)
