extends Node

class_name HealthNode

signal damaged(health: float, delta: float)
signal changed(health: float, delta: float)
signal healed(health: float, delta: float)
signal armor_changed(armor: float)
signal died()

const MAX_ARMOR: float = 100.0
const MIN_ARMOR: float = 0.0
const MIN_DAMAGE: float = -2.0

const  MAX_HEALTH: float = 100.0
const MIN_HEALTH: float = 0.0

@export var INVINSIBLE: bool = false:
	get():
		return INVINSIBLE
		
	set(value):
		if value != INVINSIBLE:
			INVINSIBLE = value
@export_range(MIN_ARMOR, MAX_ARMOR, 1.0) var ARMOR: float = MIN_ARMOR:
	get():
		return ARMOR
		
	set(value):
		if value != ARMOR:
			ARMOR = clamp(value, MIN_ARMOR, MAX_ARMOR)
			armor_changed.emit(ARMOR)


@export_range(MIN_HEALTH, MAX_HEALTH, 1.0) var health: float = MAX_HEALTH:
	get():
		return health
		
	set(value):
		if value != health:
			value = clamp(value, 0.0, MAX_HEALTH)
			var delta := value - health
			health = value
			changed.emit(health, delta)
			
			if _is_dead():
				died.emit()
			
			if delta > 0:
				healed.emit(health, delta)
			if delta < 0:
				damaged.emit(health, delta)
			
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _is_dead() -> bool:
	return health <= MIN_HEALTH

# Applies damage in float and returns health amount
func hit(damage: float = -10) -> float:
	if INVINSIBLE:
		return health
	var damageMultiplier: float = 1 - ARMOR / (MAX_ARMOR - MIN_ARMOR)
	var damageAmount: float = clamp(damage * damageMultiplier, damage, MIN_DAMAGE)
	health = health + damageAmount
	return health
	
func heal(amount: float = 10) -> float:
	health = health + amount
	return health

func reduceArmor() -> float:
	ARMOR = ARMOR - 2.0
	return ARMOR

func increaseArmor(amount: float) -> float:
	ARMOR = ARMOR + amount
	return ARMOR

func _process(delta: float) -> void:
	pass
