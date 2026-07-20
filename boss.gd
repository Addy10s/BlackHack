extends Node2D

@onready var SelfScore = get_node("SelfScore")

@onready var finale = get_node("Finale")
var deck = Globals.deck
var Cards = 2
var BossCards = 2
var current_cards = 0
var boss_current_cards = 0

var totalAmount = 0 
var bossTotal = 0
#var goal = Globals.round + 13
var max_power = Globals.max_power
var xpos = -10
var bxpos = 250
var activated = 0
var cards_array = []
var bossdeck = Deck_t.new()
func _ready():
	var drawCard = get_node("hitButton")
	drawCard.pressed.connect(_button_pressed)
	deck.shuffle()
	deck.shuffle()
	deck.shuffle()
	deck.shuffle()
	bossdeck.shuffle()
	bossdeck.shuffle()
	bossdeck.shuffle()
	drawUp()
	#BossDrawUp()

func _button_pressed():
	Cards += 1
	print(deck.iter())
	drawUp()


func BossDrawUp():
	var Diff = BossCards - boss_current_cards
	boss_current_cards += Diff
	
	for labels in Diff:
		labels += boss_current_cards
		bxpos -= 25
		var bypos = 20
		var card = TextureButton.new()
		card.flip_v = true
		card.flip_h = true

		var atlas = AtlasTexture.new()
		atlas.atlas = load("res://assets/Cards.png")
		atlas.region = bossdeck.cards[labels].get_atlas()

		card.texture_normal = preload("res://assets/cardBack.png")
		var movementTween = create_tween()
		card.position = Vector2(128,24)
		movementTween.tween_property(card, "global_position", Vector2(bxpos,bypos), 0.15)\
		.set_trans(Tween.TRANS_LINEAR)\
		.set_ease(Tween.EASE_IN_OUT)
		movementTween.finished.connect(func():card.texture_normal = atlas)
		var value = bossdeck.cards[labels].get_power()
		
		get_node("group").add_child(card)
		bossTotal += value
		get_node("BossScore").text = str(bossTotal) + "/" + str(max_power)
#
		#if deck.cards[labels].suit == Card_t.Suits_t.GOLD:
			#card.pressed.connect(flipOver.bind(card,value))
		
		
		if bossTotal > max_power:
			round_end("SUCCESS")
		elif totalAmount >= bossTotal:
			BossCards += 1
			BossDrawUp()


func drawUp():
	var Diff = Cards - boss_current_cards
	boss_current_cards += Diff
	
	for labels in Diff:
		labels += boss_current_cards
		xpos += 25
		var ypos = 84
		var card = TextureButton.new()
		var atlas = AtlasTexture.new()
		atlas.atlas = load("res://assets/Cards.png")
		atlas.region = deck.cards[labels].get_atlas()

		card.texture_normal = preload("res://assets/cardBack.png")
		var movementTween = create_tween()
		card.position = Vector2(128,24)
		movementTween.tween_property(card, "global_position", Vector2(xpos,ypos), 0.15)\
		.set_trans(Tween.TRANS_LINEAR)\
		.set_ease(Tween.EASE_IN_OUT)
		movementTween.finished.connect(func():card.texture_normal = atlas)
		var value = deck.cards[labels].get_power()
		
		cards_array.append(card)
		get_node("group").add_child(card)
		totalAmount += value
		SelfScore.text = str(totalAmount) + "/" + str(max_power)

		if deck.cards[labels].suit == Card_t.Suits_t.GOLD:
			card.pressed.connect(flipOver.bind(card,value))
		
		
		if totalAmount > max_power:
			round_end("FAIL")
		elif totalAmount >= bossTotal:
			BossCards += 1
			BossDrawUp()
		

func flipOver(card,value):
	card.texture_normal = preload("res://assets/cardBack.png")
	totalAmount -= value
	card.disabled = true
	SelfScore.text = str(totalAmount) + "/" + str(max_power)

#func hold():
	#if totalAmount == max_power:
		#round_end("PERFECT")
#
	#elif totalAmount >= goal:
		#round_end("SUCCESS")

			
func carddisable(array):
	for card in array:
		card.disabled = true
func hide_ui():
	get_node("BossScore").visible = false
	get_node("SelfScore").visible = false
	get_node("hitButton").visible = false
	#get_node("Label").visible = false
	#get_node("Label2").visible = false
	get_node("CardBack").visible = false


func round_end(ending_type):
			var endText
			match ending_type:
				"FAIL":
					endText = "YOU LOST"
					Globals.lives -= 1
					get_node("Finale/tokenUps").visible = true
					var tokenAddAmnt = Globals.round + 4
					Globals.tokens += tokenAddAmnt
					get_node("Finale/tokenUps").text = "+{0} COINS".format({"0": str(tokenAddAmnt)})

				"SUCCESS":
					endText = "YOU WON THE GAME!"
				
					#var tokenAddAmnt = Globals.round + 4
					#Globals.tokens += tokenAddAmnt
					#get_node("Finale/tokenUps").text = "+{0} COINS".format({"0": str(tokenAddAmnt)})
				"PERFECT":
					endText = "PERFECT SCORE!"
					

			var drawCard = get_node("hitButton")
			finale.visible = true
			$AnimationPlayer.play("fade_out")
			hide_ui()
			carddisable(cards_array)
			get_node("Finale/finalText").text = endText
			drawCard.disabled = true
			get_node("Finale/Okie").pressed.connect(_end_scene.bind(ending_type))
func _end_scene(ending_type):
		Globals.success = ending_type
		print(ending_type)
		match ending_type:
			"FAIL":
				get_tree().change_scene_to_file("res://map.tscn")
			"SUCCESS":
				get_tree().quit()
