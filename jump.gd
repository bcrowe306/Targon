extends State
@onready var new_player: CharacterBody2D = $"../.."
@onready var jump_sound: AudioStreamPlayer = $"../../JumpSound"



func _enter(_state_name: String):
	audio_stream.play()
	jump_sound.play()
	animated_sprite.play(animation_name)
	timer.stop()
