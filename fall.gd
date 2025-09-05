extends State
@onready var new_player: CharacterBody2D = $"../.."

func _enter(_state_name: String):
	timer.start()
	animated_sprite.play(animation_name)

func _exit(next_state: String):
	if next_state != "Jump" and next_state != "Jump2":
		new_player.jump_count = 0 
