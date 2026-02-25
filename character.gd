extends CharacterBody2D
const TILE_SIZE := 16
@onready var ray = $RayCast2D
const neutral = preload("res://assets/character.png")
const right = preload("res://assets/characterRight.png")
const left = preload("res://assets/characterLeft.png")
const up = preload("res://assets/CharacterUp.png")
var is_currenly_tween: bool = false
var input_stack = []


func _input(event):
	if event.is_action_pressed("moveRight"):
		input_stack.push_back("moveRight")
	elif event.is_action_pressed("moveLeft"):
		input_stack.push_back("moveLeft")
	elif event.is_action_pressed("moveUp"):
		input_stack.push_back("moveUp")
	elif event.is_action_pressed("moveDown"):
		input_stack.push_back("moveDown")
		
	if event.is_action_released("moveRight"):
		input_stack.erase("moveRight")
	elif event.is_action_released("moveLeft"):
		input_stack.erase("moveLeft")
	elif event.is_action_released("moveUp"):
		input_stack.erase("moveUp")
	elif event.is_action_released("moveDown"):
		input_stack.erase("moveDown")
	


func _process(_delta):
	var move_direction := Vector2.ZERO
	
	
	if input_stack.size() > 0:
		var last_input = input_stack.back()
		match last_input:
			"moveRight": 
				move_direction.x = 1
			"moveLeft":
				move_direction.x = -1
			"moveDown": 
				move_direction.y = 1
			"moveUp": 
				move_direction.y = -1

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
	if !ray.is_colliding() and !is_currenly_tween:
		is_currenly_tween = true
		var movementTween = create_tween()
		var test = global_position + direction * TILE_SIZE
		movementTween.tween_property(self, "global_position", test, 0.15)\
		.set_trans(Tween.TRANS_LINEAR)\
		.set_ease(Tween.EASE_IN_OUT)
		
		movementTween.finished.connect(func():   
			check_tile_data()
			is_currenly_tween = false)
		
	else:
		pass
	


@onready var tile_map_layer = get_parent()
func check_tile_data():
	var map_pos = tile_map_layer.local_to_map(global_position)
	
	var tile_data = tile_map_layer.get_cell_tile_data(map_pos)
	
	if tile_data:
		var type = tile_data.get_custom_data("tileType")
		
		if type == "openDoor":
			tile_map_layer.set_cell(map_pos,0,Vector2i(0,3))
		elif type == "encounter":
			Globals.playerPosition = global_position

			get_tree().change_scene_to_file("res://gameplay.tscn")
		elif type == "shop":
			Globals.playerPosition = global_position

			get_tree().change_scene_to_file("res://shop.tscn")
		else:
			pass



func update_area():
	var map_pos = tile_map_layer.local_to_map(global_position)
	var tile_data = tile_map_layer.get_cell_tile_data(map_pos)
	if tile_data:
		if Globals.SUCCESS_t[Globals.success] in [1,2]:
			tile_map_layer.set_cell(map_pos,0,Vector2i(3,4))
			Globals.tokens += Globals.round + 4



func _ready() -> void:

	for i in Globals.lives:
		var life_hud = TextureRect.new()
		life_hud.global_position = Vector2i(16 * i - 128, -64)
		life_hud.texture = load("res://assets/lives.png")
		$Camera2D.add_child(life_hud)

	if Globals.lives <= 0:
		get_tree().change_scene_to_file("res://map.tscn")

	
	global_position = Globals.playerPosition
	if Globals.round > 0:
		update_area()
		
		
	if Globals.SUCCESS_t.get(Globals.success, -1) != 2:
		Globals.round += 1
