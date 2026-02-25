extends Node2D




func _ready():
	print(get_shop_items())
	var leaveShop = get_node("leaveShop")
	leaveShop.pressed.connect(exit)

	var coin_label = get_node("coinLabel") 
	coin_label.text = str(Globals.tokens)
	add_cards()


func add_cards():
	var items = get_shop_items()
	var iter = 0
	var y = 49
	var x = 28
	for card in items:
		print(card,"   ", x,"   " , y )

		if x == 268:
			x = 28
		if iter < 6:
			y = 49
		elif iter >= 6:
			y = 96
		var newCard = Sprite2D.new()
		newCard.position = Vector2i(x,y)
		var cardPrice = Button.new()
		
		
		match card:
			"lives":
				newCard.texture = load("res://assets/buyLives.png")

			"max_up":
				newCard.texture = load("res://assets/buyMaxUp.png")
					
			_:
				var atlas = AtlasTexture.new()
				atlas.atlas = load("res://assets/Cards.png")
				var realCard = Card_t.new(Card_t.Suits_t.GOLD, card)
				atlas.region = realCard.get_atlas()
				newCard.texture = atlas
		var price = 10
		cardPrice.text = str(price)
		cardPrice.add_theme_font_override("font",load("res://assets/PixelFont.png"))
		cardPrice.add_theme_font_size_override("font_size", 6)
		cardPrice.flat = true
		cardPrice.position = Vector2i(x - 10,y + 15)
		add_child(newCard)
		add_child(cardPrice)
		cardPrice.pressed.connect( buy.bind( price, card ) )
		x += 40
		iter+=1
	
func buy( price, item ):
	if Globals.tokens >= price:
		match item:
			"lives":
				Globals.tokens -= price
				Globals.lives +=1
			"max_up":
				Globals.tokens -= price
				Globals.max_power +=1
				
				
			_:
				Globals.tokens -= price
				var realCard = Card_t.new(Card_t.Suits_t.GOLD, item)
				Globals.deck.append(realCard)
		var coin_label = get_node("coinLabel") 
		coin_label.text = str(Globals.tokens)
		
	
	
func exit():
	Globals.round -= 1
	Globals.success = "PERFECT"
	get_tree().change_scene_to_file("res://map.tscn")
	
	
	

func get_shop_items() -> Array:
	var base_array = ["lives","max_up"]
	var add_numbers = [1,2,3,4,5,6,7,8,9,10,11,12,13]
	add_numbers.shuffle()
	add_numbers.shuffle()
	base_array.append_array(add_numbers)
	base_array.resize(12)
	print(base_array)
	return base_array
