extends CharacterBody2D
class_name Slime

@onready var animation_tree := $AnimationTree
@onready var playback = animation_tree.get("parameters/playback")

const SPEED := 75
var health := 1
enum State {IDLE, IDLE_BOUNCE, JUMP, HIT, DEATH}
var current_state = State.IDLE


func _physics_process(delta: float) -> void:
	if health <= 0:
		current_state = State.DEATH
	if current_state == State.IDLE:
		playback.travel("idle")
	if current_state == State.DEATH:
		playback.travel("death")



func set_blend_pos(p: Vector2) -> void:
	animation_tree.set("parameters/idle/blend_position", p)
	animation_tree.set("parameters/idle_bounce/blend_position", p)
	animation_tree.set("parameters/jump/blend_position", p)
	animation_tree.set("parameters/hit/blend_position/blend_position", p)
	animation_tree.set("parameters/death/blend_position", p)


func _on_damage_detector_body_entered(body):
	print(body.name)
	if "Player" in body.name:
		print("Player hurt!")
		body.health -= 1
