extends AudioStreamPlayer
const SFX__VOX_FEMALE_06: AudioStreamWAV = preload("res://resources/sfx/SFX- Vox-Female-06.wav")
const SFX__VOX_FEMALE_07: AudioStreamWAV = preload("res://resources/sfx/SFX- Vox-Female-07.wav")
const SFX__VOX_FEMALE_09: AudioStreamWAV = preload("res://resources/sfx/SFX- Vox-Female-09.wav")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_player_attack(attack_number: int) -> void:
	if attack_number == 0:
		stream =SFX__VOX_FEMALE_06 
	elif attack_number == 1:
		stream = SFX__VOX_FEMALE_07
	else:
		stream = SFX__VOX_FEMALE_09
	play()# Replace with function body.
