extends CharacterBody2D
signal side_scene_finished
const TILE_SIZE := 16
@onready var ray = $RayCast2D

const neutral = preload("res://assets/character.png")
const right = preload("res://assets/characterRight.png")
const left = preload("res://assets/characterLeft.png")
const up = preload("res://assets/CharacterUp.png")
func _unhandled_input(event):
	var move_direction := Vector2.ZERO
	if event.is_action_pressed("moveRight"): move_direction.x = 1
	elif event.is_action_pressed("moveLeft"): move_direction.x = -1
	elif event.is_action_pressed("moveDown"): move_direction.y = 1
	elif event.is_action_pressed("moveUp"): move_direction.y = -1
	
	if move_direction != Vector2.ZERO:
		match str(move_direction):
			"(-1.0, 0.0)": $Sprite2D.texture = left
			"(0.0, 1.0)": $Sprite2D.texture = neutral
			"(1.0, 0.0)": $Sprite2D.texture = right
			"(0.0, -1.0)": $Sprite2D.texture = up
		move_to_grid(move_direction)

func move_to_grid(direction: Vector2):
	ray.target_position = direction * TILE_SIZE
	
	ray.force_raycast_update()
	
	if !ray.is_colliding():
		global_position += direction * TILE_SIZE
		check_tile_data()
	else:
		pass
	
func on_side_scene_finished():
	print("test?")

func _on_SideSceneLayer_child_exiting_tree(_node: Node) -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	side_scene_finished.emit()

func show_side_scene(side_scene: Node) -> void:
	print("Test Test Test did this work?")
	get_parent().add_child(side_scene)
	side_scene.setup("meow test")
	process_mode = Node.PROCESS_MODE_DISABLED


@onready var tile_map_layer = get_parent()
func check_tile_data():
# 1. Get the map position (the grid coordinates)
	var map_pos = tile_map_layer.local_to_map(global_position)
	
	# 2. Get the data object for that specific cell
	var tile_data = tile_map_layer.get_cell_tile_data(map_pos)
	
	# 3. Check if the tile actually exists and has data
	if tile_data:
		var type = tile_data.get_custom_data("tileType")
		
		if type == "openDoor":
			tile_map_layer.set_cell(map_pos,0,Vector2i(0,3))
		elif type == "encounter":
			Globals.playerPosition = global_position

			get_tree().change_scene_to_file("res://gameplay.tscn")
		else:
			pass


func _ready() -> void:
	global_position = Globals.playerPosition
	connect("side_scene_finished", on_side_scene_finished)
