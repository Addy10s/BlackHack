extends Node2D

@onready var totalLabel = get_node("Total")
var deck = Deck_t.new()


var Cards = 2
var totalAmount = 0 

var goal = randi_range(10,18)
func _button_pressed():
	Cards += 1
	drawUp()

func _ready():
	var goalLabel = get_node("Goal")
	#var totalLabel = get_node("Total")
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
		card.position = Vector2(positioning,100)

		card.texture = atlas
		add_child(card)

		
		
		
		totalAmount += deck.cards[labels].get_power()
		totalLabel.text = str(totalAmount)
		if totalAmount > 21:
			var drawCard = get_node("hitButton")
			totalLabel.text = "YOU LOST"
			drawCard.disabled = true
			await get_tree().create_timer(0.5).timeout
			get_tree().quit()
		
		
func hold():
	if totalAmount == 21:
		totalLabel.text = "PERFECT SCORE!"
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://map.tscn")

	elif totalAmount > goal:
		totalLabel.position = Vector2(100,50)
		totalLabel.text = "YOU GOT IT!"
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_file("res://map.tscn")
