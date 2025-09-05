extends State
@onready var new_player: CharacterBody2D = $"../.."
@onready var health_node: HealthNode = $"../../HealthNode"

func _enter(_prev: String):
	print("Ready State")
	new_player.reset()
