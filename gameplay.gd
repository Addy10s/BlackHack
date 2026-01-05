extends Node2D

static func setup(test: String):
	print(test)
@onready var totalLabel = get_node("Total")

var deck = [
	"ha","h2","h3","h4","h5","h6","h7","h8","h9","h10","hj","hq","hk",
	"ca","c2","c3","c4","c5","c6","c7","c8","c9","c10","cj","cq","ck",
	"da","d2","d3","d4","d5","d6","d7","d8","d9","d10","dj","dq","dk",
	"sa","s2","s3","s4","s5","s6","s7","s8","s9","s10","sj","sq","sk"
	]
var Cards = 2
var totalAmount = 0 
var cardPower = {
	"ha": 11,"h2": 2,"h3": 3,"h4": 4,"h5": 5,"h6": 6,"h7": 7,"h8": 8,"h9": 9,"h10": 10,"hj": 10,"hq": 10,"hk": 10,
	"ca": 11,"c2": 2,"c3": 3,"c4": 4,"c5": 5,"c6": 6,"c7": 7,"c8": 8,"c9": 9,"c10": 10,"cj": 10,"cq": 10,"ck": 10,
	"da": 11,"d2": 2,"d3": 3,"d4": 4,"d5": 5,"d6": 6,"d7": 7,"d8": 8,"d9": 9,"d10": 10,"dj": 10,"dq": 10,"dk": 10,
	"sa": 11,"s2": 2,"s3": 3,"s4": 4,"s5": 5,"s6": 6,"s7": 7,"s8": 8,"s9": 9,"s10": 10,"sj": 10,"sq": 10,"sk": 10
}
var goal = randi_range(10,18)
func _button_pressed():
	Cards += 1
	drawUp()

func _ready():
	var goalLabel = get_node("Goal")
	#var totalLabel = get_node("Total")

	var temp_cards = deck.duplicate()
	var holdHand = get_node("holdButton")
	holdHand.pressed.connect(hold)
	var drawCard = get_node("hitButton")
	drawCard.pressed.connect(_button_pressed)
	temp_cards.resize(5)
	for item in temp_cards:
		print(cardPower[item])
	print("")
	print("")
	deck.shuffle()
	for item in deck:
		print(item)
	goalLabel.text = str(goal)
	print("goal is:", goal)
	print(deck[0], deck[1])
	totalLabel.text = str(cardPower[deck[0]] + cardPower[deck[1]])
	drawUp()
	
	
func drawUp():
	totalAmount = 0
	var positioning = -30
	for labels in Cards:
		positioning += 45
		var newLabel = Label.new()
		newLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		newLabel.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		newLabel.text = str(deck[labels])
		newLabel.position = Vector2(positioning,100)
		newLabel.add_theme_font_size_override("font_size", 20)
		add_child(newLabel)
		print("number:",labels, "Value:",newLabel.text)
		totalAmount += cardPower[deck[labels]]
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
