extends Node

@onready var boarHitSounds: Array[AudioStreamWAV] = [
	preload("res://resources/sfx/Pig Sounds/Hit Sound-001.wav"),
	preload("res://resources/sfx/Pig Sounds/Hit Sound-002.wav"),
	preload("res://resources/sfx/Pig Sounds/Hit Sound-003.wav"),
	preload("res://resources/sfx/Pig Sounds/Hit Sound-010.wav"),
	preload("res://resources/sfx/Pig Sounds/Hit Sound-013.wav"),
	preload("res://resources/sfx/Pig Sounds/Hit Sound-015.wav"),
	preload("res://resources/sfx/Pig Sounds/Hit Sound-017.wav")
]
var boarHitSoundIndex: int = 0

func getBoarHitSound() -> AudioStreamWAV:
	boarHitSoundIndex += 1
	boarHitSoundIndex = boarHitSoundIndex % boarHitSounds.size()
	return boarHitSounds[boarHitSoundIndex]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
