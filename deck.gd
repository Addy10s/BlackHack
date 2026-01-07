extends Object
class_name Deck_t

var cards = Array()


func create_default_deck() -> void:
	self.cards = Array()
	for suit in Card_t.Suits_t:
		for value in range( 1, 14 ):
			self.cards.append( Card_t.new( Card_t.Suits_t[ suit ], value ) )
			
func append( card: Card_t ) -> void:
	self.cards.append( card )
			
func _init() -> void:
	self.create_default_deck()

func shuffle():
	cards.shuffle()
