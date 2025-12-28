extends CharacterBody2D

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
	else:
		pass
