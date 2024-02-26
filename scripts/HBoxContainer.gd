extends HBoxContainer


@onready var heart_1 = $Heart1
@onready var heart_2 = $Heart2
@onready var heart_3 = $Heart3


func _process(_delta: float) -> void:
	if Global.player_health == 3:
		heart_1.visible = true
		heart_2.visible = true
		heart_3.visible = true
	elif Global.player_health == 2:
		heart_1.visible = true
		heart_2.visible = true
		heart_3.visible = false
	elif Global.player_health == 1:
		heart_1.visible = true
		heart_2.visible = false
		heart_3.visible = false
	elif Global.player_health <= 0:
		heart_1.visible = false
		heart_2.visible = false
		heart_3.visible = false
