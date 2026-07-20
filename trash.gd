extends Node2D
@onready var deck = Globals.deck
var booltest = false
var remove_cards = []
func _ready() -> void:
	get_node("coinLabel").text = str(Globals.tokens)
	get_node("Exit").pressed.connect(exit)
	create_cards()
	
	
func create_cards():
	deck.shuffle()
	var x = -12
	var y = 48
	for i in range(0,12):
		print(str(deck.cards[i]) +  "\n")
		var card = deck.cards[i]
		x +=40
		if i >= 6:
			y = 97
			if booltest == false:
				x -= 241
				booltest = true
		var price = 15
		var cardPrice = Button.new()
		
		cardPrice.text = "SELL"
		cardPrice.add_theme_font_override("font",load("res://assets/PixelFont.png"))
		cardPrice.add_theme_font_size_override("font_size", 8)
		cardPrice.flat = true
		cardPrice.position = Vector2i(x - 14 ,y + 15)
		add_child(cardPrice)
		cardPrice.pressed.connect( sell.bind( cardPrice, card ) )
		
		var newCard = Sprite2D.new()
		newCard.position = Vector2i(x,y)
		
		var atlas = AtlasTexture.new()
		atlas.atlas = load("res://assets/Cards.png")
		atlas.region = card.get_atlas()
		newCard.texture = atlas
		#newCard.texture = load("res://assets/cardBack.png")
		
		add_child(newCard)
	

func sell(button,item):
		button.disabled = true
		if Globals.tokens >= 15:
			var CorrectSound = preload("res://assets/successfulBuy.wav")
			$AudioStreamPlayer.stream = CorrectSound
			$AudioStreamPlayer.play()

			Globals.tokens -= 15
			remove_cards.append(item)
			var coin_label = get_node("coinLabel") 
			coin_label.text = str(Globals.tokens)
		else:
			var incorrectSound = preload("res://assets/unsuccessfulBuy.wav")
			$AudioStreamPlayer.stream = incorrectSound
			$AudioStreamPlayer.play()
			

	
func exit():
	#print(Globals.deck.cards)
	#print(remove_cards)
	for i in remove_cards:
		Globals.deck.cards.erase(i)
	#print(Globals.deck.cards)

	#Globals.round -= 1
	Globals.success = "PERFECT"
	get_tree().change_scene_to_file("res://map.tscn")
