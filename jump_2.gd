extends State
@onready var jump_sound: AudioStreamPlayer = $"../../JumpSound"


func _enter(_state_name: String):
	jump_sound.play()
	audio_stream.play()
	animated_sprite.play(animation_name)
	timer.stop()
