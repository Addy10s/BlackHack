extends Node
class_name Card_t

enum Suits_t { HEARTS, DIAMONDS, SPADES, CLUBS }

var suit: Suits_t
var value: int

const X_SIZE = 24
const Y_SIZE = 32

func _init(suit: Suits_t, value: int) -> void:
	self.suit = suit
	self.value = value
	
func get_power() -> int:
	#handle Aces
	if self.value == 1:
		return 11
	elif self.value > 10:
		return 10

	else:
		return self.value

func get_suit_str() -> String:
	if self.suit == Suits_t.HEARTS:
		return 'h'
	elif self.suit == Suits_t.DIAMONDS:
		return 'd'
	elif self.suit == Suits_t.SPADES:
		return 's'
	elif self.suit == Suits_t.CLUBS:
		return 'c'
	else:
		assert(self.suit in Suits_t)
		return ""
		
func get_value_str() -> String:
	if self.value == 1:
		return 'A'
	elif self.value == 11:
		return 'J'
	#finish me
	else:
		return str(value)

		
func _to_string() -> String:
	return self.get_suit_str() + self.get_value_str()

func get_atlas() -> Rect2:
	return Rect2( self.suit * self.X_SIZE, (value - 1) * self.Y_SIZE, self.X_SIZE, self.Y_SIZE )
