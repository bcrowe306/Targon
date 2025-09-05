extends State
@onready var health_node: HealthNode = $"../../HealthNode"
@onready var new_player: CharacterBody2D = $"../.."

func _ready() -> void:
	animated_sprite.animation_finished.connect(self.on_finished)

func _enter(_prev: String):
	animated_sprite.play(animation_name)
	health_node.INVINSIBLE = true
	new_player.ACCEPT_INPUT = false
	new_player.set_collision_layer_value(2, false)
	new_player.set_collision_mask_value(2, false)
	new_player.set_collision_mask_value(3, false)
	new_player.set_collision_mask_value(4, false)

func  on_finished():
	if animated_sprite.animation == animation_name:
		new_player.died.emit(health_node.health)
