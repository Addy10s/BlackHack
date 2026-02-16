extends Node2D
@onready var Again = get_node("Again")
@onready var Leave = get_node("Leave")


func leave():
	$Label.visible = true
	await get_tree().create_timer(1.5).timeout
	get_tree().quit()

func again():
	Globals.playerPosition = Vector2i(8,56)
	Globals.success = null
	Globals.round = 0
	Globals.max_power = 21
	Globals.lives = 3
	Globals.tokens = 0
	get_tree().change_scene_to_file("res://map.tscn")


func _ready() -> void:
	Leave.pressed.connect(leave)
	Again.pressed.connect(again)
