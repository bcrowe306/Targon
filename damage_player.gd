extends AudioStreamPlayer


var soundArray: Array[AudioStreamWAV] = [
	preload("res://resources/sfx/Jazmin J-Hurt1.wav"),
	preload("res://resources/sfx/Jazmin J-Hurt2.wav"),
	preload("res://resources/sfx/Jazmin J-Hurt3.wav"),
	preload("res://resources/sfx/Jazmin J-Hurt4.wav"),
	preload("res://resources/sfx/Jazmin J-Hurt5.wav")
]

var index: int = 0

func _on_health_node_damaged(_health: float, _delta: float) -> void:
	playSound()

func playSound():
	stream = soundArray[index]
	play()
	index += 1
	index = index % soundArray.size()
