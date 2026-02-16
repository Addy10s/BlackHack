extends Node2D




func _ready():
	var leaveShop = get_node("leaveShop")
	leaveShop.pressed.connect(exit)

	var coin_label = get_node("coinLabel") 
	coin_label.text = str(Globals.tokens)
	add_cards()


func add_cards():
	var livesCard = Sprite2D.new()
	livesCard.position = Vector2i(28,49)
	var livesPrice = Button.new()	
	
	livesCard.texture = load("res://assets/buyLives.png")
	var price = 10
	livesPrice.text = str(price)
	
	livesPrice.add_theme_font_override("font",load("res://assets/PixelFont.png"))
	livesPrice.add_theme_font_size_override("font_size", 6)
	livesPrice.flat = true
	livesPrice.position = Vector2i(18,64)
	add_child(livesCard)
	add_child(livesPrice)
	livesPrice.pressed.connect( buy.bind( price, "lives" ) )
	
	
	
func buy( price, item ):
	if Globals.tokens >= price:
		match item:
			"lives":
				Globals.tokens -= price
				Globals.lives +=1
				
				
			_:
				get_tree().quit()
		var coin_label = get_node("coinLabel") 
		coin_label.text = str(Globals.tokens)
		
	
	
func exit():
	Globals.round -= 1
	Globals.success = "PERFECT"
	get_tree().change_scene_to_file("res://map.tscn")
