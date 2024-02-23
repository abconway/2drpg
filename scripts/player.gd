extends CharacterBody2D
class_name Player


@onready var animation_tree := $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var sword_collision_shape_2d = $Marker2D/Sword/CollisionShape2D

const SPEED := 100

var previous_direction: Vector2
var is_attacking = false
var health = 3


func _ready() -> void:
	sword_collision_shape_2d.disabled = true


func _physics_process(delta: float) -> void:
	if health <= 0:
		queue_free()
	if not is_attacking and Input.is_action_just_pressed("player_attack"):
		is_attacking = true
		playback.travel("attack")
	elif not is_attacking:
		var direction := Vector2(
			Input.get_axis("player_move_left", "player_move_right"),
			Input.get_axis("player_move_up", "player_move_down"),
		)
		if direction == Vector2.ZERO:
			playback.travel("idle")
			set_blend_pos(previous_direction)
		else:
			playback.travel("walk")
			previous_direction = direction
			set_blend_pos(direction)
		velocity = direction * SPEED
		move_and_slide()


func set_blend_pos(p: Vector2) -> void:
	animation_tree.set("parameters/idle/blend_position", p)
	animation_tree.set("parameters/walk/blend_position", p)
	animation_tree.set("parameters/attack/blend_position", p)


func attack_complete() -> void:
	is_attacking = false
	playback.travel("idle")


func _on_sword_body_entered(body):
	if body.name == "Slime":
		body.health -= 1 # Replace with function body.
