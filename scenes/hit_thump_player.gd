extends AudioStreamPlayer

var hitSounds: Array[AudioStreamWAV] = [
	preload("res://resources/sfx/DesignedPunch3.wav"),
	preload("res://resources/sfx/DesignedPunch4.wav")
]
var currentSound: int = 0


func get_hit_sound() -> AudioStreamWAV:
	currentSound += 1
	currentSound = currentSound % hitSounds.size()
	return hitSounds[currentSound]
	
func play_damaged_sound():
	stream = get_hit_sound()
	play()
	


func _on_health_node_damaged(_health: float, _delta: float) -> void:
	play_damaged_sound() # Replace with function body.
