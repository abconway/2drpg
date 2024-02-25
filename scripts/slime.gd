extends CharacterBody2D
class_name Slime


@onready var animation_tree := $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var bounce_timer = $BounceTimer

const SPEED := 50
var health := 1
enum State {IDLE, IDLE_BOUNCE, JUMP, HIT, DEATH}
var current_state = State.IDLE
var target_body


func _physics_process(delta: float) -> void:
	if health <= 0:
		current_state = State.DEATH
	if current_state == State.IDLE:
		playback.travel("idle")
	if current_state == State.DEATH:
		playback.travel("death")
	if current_state == State.IDLE_BOUNCE:
		playback.travel("idle_bounce")
		if bounce_timer.is_stopped():
			bounce_timer.start()
	if current_state == State.JUMP:
		jump()


func set_blend_pos(p: Vector2) -> void:
	animation_tree.set("parameters/idle/blend_position", p)
	animation_tree.set("parameters/idle_bounce/blend_position", p)
	animation_tree.set("parameters/jump/blend_position", p)
	animation_tree.set("parameters/hit/blend_position/blend_position", p)
	animation_tree.set("parameters/death/blend_position", p)


func jump() -> void:
	print("jump")
	var target_vector: Vector2 = target_body.position - position
	if target_vector.length() > SPEED:
		target_vector = target_vector.normalized() * SPEED
	position = position + target_vector 
	current_state = State.IDLE


func _on_damage_detector_body_entered(body):
	print(body.name)
	if "Player" in body.name:
		print("Player hurt!")
		body.health -= 1


func _on_player_detector_body_entered(body):
	print(body.name)
	if "Player" in body.name:
		current_state = State.IDLE_BOUNCE
		target_body = body


func _on_player_detector_body_exited(body):
	print(body.name)
	if "Player" in body.name:
		current_state = State.IDLE


func _on_bounce_timer_timeout():
	current_state = State.JUMP
