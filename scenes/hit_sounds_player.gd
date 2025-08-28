extends AudioStreamPlayer

const HIT_SOUND_009 = preload("res://resources/sfx/Pig Sounds/Hit Sound-009.wav")



func play_damaged_sound():
	stream = Sounds.getBoarHitSound()
	play()
	
func play_dying_sound():
	stream = HIT_SOUND_009
	play()
	
func _on_health_node_damaged(health: float, delta: float) -> void:
	play_damaged_sound() 
