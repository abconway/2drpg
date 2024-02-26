extends CharacterBody2D
class_name Slime


@onready var animation_tree := $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")
@onready var bounce_timer = $BounceTimer

const SPEED := 50
var health := 1
enum State {IDLE, IDLE_BOUNCE, JUMP, JUMPING, HIT, DEATH}
var current_state = State.IDLE
var target_body


func _physics_process(delta: float) -> void:
	if health <= 0:
		current_state = State.DEATH
	if current_state == State.IDLE:
		playback.travel("idle")
	elif current_state == State.DEATH:
		playback.travel("death")
	elif current_state == State.IDLE_BOUNCE:
		playback.travel("idle_bounce")
		if not target_body:
			current_state = State.IDLE
		if bounce_timer.is_stopped():
			bounce_timer.start()
	elif current_state == State.JUMP:
		current_state = State.JUMPING
		jump()
	elif current_state == State.JUMPING:
		pass


func set_blend_pos(p: Vector2) -> void:
	animation_tree.set("parameters/idle/blend_position", p)
	animation_tree.set("parameters/idle_bounce/blend_position", p)
	animation_tree.set("parameters/jump/blend_position", p)
	animation_tree.set("parameters/hit/blend_position/blend_position", p)
	animation_tree.set("parameters/death/blend_position", p)


func jump() -> void:
	if not target_body:
		return
	var target_vector: Vector2 = target_body.position - position
	if target_vector.length() > SPEED:
		target_vector = target_vector.normalized() * SPEED
	#position = position + target_vector
	playback.travel("jump")
	var tween = get_tree().create_tween()
	tween.tween_property($".", "position", position + target_vector, 0.7)
	tween.set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN_OUT)
	tween.finished.connect(jumping_finished)


func jumping_finished():
	current_state = State.IDLE_BOUNCE
	return true


func _on_damage_detector_body_entered(body):
	if body.is_in_group("Player"):
		print("Player hurt!")
		body.health -= 1


func _on_player_detector_body_entered(body):
	if body.is_in_group("Player"):
		current_state = State.IDLE_BOUNCE
		target_body = body


func _on_player_detector_body_exited(body):
	if body.is_in_group("Player"):
		current_state = State.IDLE
		target_body = null


func _on_bounce_timer_timeout():
	current_state = State.JUMP
