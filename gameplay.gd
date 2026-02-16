extends Node2D

@onready var totalLabel = get_node("Total")

@onready var finale = get_node("Finale")
var deck = Deck_t.new()
var Cards = 2
var totalAmount = 0 
var goal = Globals.round + 13
var max_power = Globals.max_power

func _button_pressed():
	Cards += 1
	drawUp()

func _ready():
	var goalLabel = get_node("Goal")
	var holdHand = get_node("holdButton")
	holdHand.pressed.connect(hold)
	var drawCard = get_node("hitButton")
	drawCard.pressed.connect(_button_pressed)

	deck.shuffle()
	goalLabel.text = str(goal)

	drawUp()
	

func drawUp():
	totalAmount = 0
	var positioning = -30


	for labels in Cards:
		positioning += 45
		
		var card = Sprite2D.new()
		var atlas = AtlasTexture.new()
		atlas.atlas = load("res://assets/Cards.png")
		atlas.region = deck.cards[labels].get_atlas()
		card.position = Vector2(positioning,60)

		card.texture = atlas
		add_child(card)


		totalAmount += deck.cards[labels].get_power()
		totalLabel.text = str(totalAmount)
		if totalAmount > max_power:
			var drawCard = get_node("hitButton")
			finale.visible = true
			finale.text = "YOU LOST"
			drawCard.disabled = true
			await get_tree().create_timer(1).timeout
			Globals.success = "FAIL"
			Globals.lives -= 1
			get_tree().change_scene_to_file("res://map.tscn")



func hold():
	if totalAmount == max_power:
		finale.text = "PERFECT SCORE!"
		finale.visible = true
		await get_tree().create_timer(1).timeout
		Globals.success = "PERFECT"
		get_tree().change_scene_to_file("res://map.tscn")

	elif totalAmount >= goal:
		finale.text = "YOU GOT IT!"
		finale.visible = true
		Globals.success = "SUCCESS"
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://map.tscn")
