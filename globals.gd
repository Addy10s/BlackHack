extends Node

var playerPosition = Vector2i(8,56)
enum SUCCESS_t { FAIL, SUCCESS, PERFECT }
var success
@warning_ignore("shadowed_global_identifier")
var round = 0
var max_power = 2100
var lives = 3
var tokens = 100
var deck = Deck_t.new()
