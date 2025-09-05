extends Node

signal coins_changed(coins: int, delta: int)
signal diamonds_changed(coins: int, delta: int)
signal xp_changed(coins: int, delta: int)

var coins: int = 0
var diamonds: int = 0
var xp: int = 0

const MIN_COUNT: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func modify_coins(amount: int) -> int:
	coins = max(coins + amount, MIN_COUNT)
	coins_changed.emit(coins, amount)
	return coins
	

func spend_coins(amount: int) -> bool:
	amount = abs(amount)
	if amount > coins:
		return false
	else:
		coins -= amount
		coins_changed.emit(coins, -amount)
		return true
		
		
func modify_diamonds(amount: int) -> int:
	diamonds = max(diamonds + amount, MIN_COUNT)
	diamonds_changed.emit(diamonds, amount)
	return coins
	
func spend_diamonds(amount: int) -> bool:
	amount = abs(amount)
	if amount > diamonds:
		return false
	else:
		diamonds -= amount
		diamonds_changed.emit(diamonds, -amount)
		return true
		
func modify_xp(amount: int) -> int:
	xp = max(xp + amount, MIN_COUNT)
	xp_changed.emit(xp, amount)
	return coins
	
func spend_xp(amount: int) -> bool:
	amount = abs(amount)
	if amount > xp:
		return false
	else:
		xp -= amount
		xp_changed.emit(xp, -amount)
		return true
