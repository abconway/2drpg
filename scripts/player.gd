extends CharacterBody2D
class_name Player


@onready var animation_tree := $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var sword_collision_shape_2d = $Marker2D/Sword/CollisionShape2D
@onready var dash_timer = $DashTimer
@onready var dash_particles = $DashParticles

var speed := 100

var previous_direction: Vector2
var is_attacking = false
var is_dashing = false


func _ready() -> void:
	sword_collision_shape_2d.disabled = true
	dash_timer.timeout.connect(dash_complete)


func _physics_process(delta: float) -> void:
	if Global.player_health <= 0:
		queue_free()
	if not is_attacking and Input.is_action_just_pressed("player_attack"):
		is_attacking = true
		playback.travel("attack")
	elif not is_attacking and Input.is_action_just_pressed("player_dash"):
		if not is_dashing:
			speed *= 2
			is_dashing = true
			dash_timer.start()
			dash_particles.emitting = true
	elif not is_attacking:
		var direction := Vector2(
			Input.get_axis("player_move_left", "player_move_right"),
			Input.get_axis("player_move_up", "player_move_down"),
		).normalized()
		if direction == Vector2.ZERO:
			playback.travel("idle")
			set_blend_pos(previous_direction)
		else:
			playback.travel("walk")
			previous_direction = direction
			set_blend_pos(direction)
		velocity = direction * speed
		move_and_slide()


func set_blend_pos(p: Vector2) -> void:
	animation_tree.set("parameters/idle/blend_position", p)
	animation_tree.set("parameters/walk/blend_position", p)
	animation_tree.set("parameters/attack/blend_position", p)


func attack_complete() -> void:
	is_attacking = false
	playback.travel("idle")


func dash_complete() -> void:
	dash_particles.emitting = false
	is_dashing = false
	speed /= 2


func _on_sword_body_entered(body):
	if body.is_in_group("Enemies"):
		body.health -= 1
		body.current_state = body.State.HIT
