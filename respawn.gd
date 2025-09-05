extends State
@onready var new_player: CharacterBody2D = $"../.."

func _ready() -> void:
	timer.timeout.connect(self.on_timeout)

func _enter(_prev: String):
	timer.start()
	animated_sprite.play(animation_name)
	
func on_timeout():
	new_player.state_machine.state = "Ready"
	
