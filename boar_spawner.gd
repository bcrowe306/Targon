extends Timer
const MOB_BOAR_WHITE = preload("res://scenes/mob_boar_white.tscn")

@export var SPAWN_POSITION: Vector2i = Vector2i(0, 0)
var accum: int = 0
func _on_timeout() -> void:
	var new_boar = MOB_BOAR_WHITE.instantiate()
	new_boar.position = Vector2(100, -100)
	new_boar.set_health(30.0)
	var d = -1
	if accum % 2 == 0:
		d = 1
	new_boar.direction = d
	get_parent().add_child(new_boar) # Replace with function body.
	accum +=1
