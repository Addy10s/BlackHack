extends Node

var playerPosition = Vector2i(8,56)
enum SUCCESS_t { FAIL, SUCCESS, PERFECT }
var success
@warning_ignore("shadowed_global_identifier")
var round = 0
var max_power = 21
var lives = 3
var tokens = 0
var deck = Deck_t.new()
