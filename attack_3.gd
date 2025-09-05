extends State
@onready var attack_grunts: AudioStreamPlayer = $"../../AttackGrunts"
var animation_ended: bool = false
@onready var sword: Area2D = $"../../Sword"

func _ready() -> void:
	animated_sprite.animation_finished.connect(self.on_finished)

func on_finished():
	animation_ended = true

func _enter(_prev_state: String):
	sword._on_player_attack(2)
	attack_grunts._on_player_attack(2)
	audio_stream.play()
	animation_ended = false
	animated_sprite.play(animation_name)

func _exit(_next_state: String):
	pass
	
func state_guard(next_state) -> bool:
	if next_state == "Attack2" or next_state == "Attack3" or next_state == "Tumble" or next_state == "Attack1":
		return true
	else:
		return animation_ended
