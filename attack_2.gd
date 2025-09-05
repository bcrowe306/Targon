extends State
@onready var new_player: CharacterBody2D = $"../.."
@onready var attack_grunts: AudioStreamPlayer = $"../../AttackGrunts"
@onready var sword: Area2D = $"../../Sword"

var animation_ended: bool = false

func _ready() -> void:
	animated_sprite.animation_finished.connect(self.on_finished)


func on_finished():
	animation_ended = true

func _enter(_prev_state: String):
	sword._on_player_attack(1)
	audio_stream.play()
	attack_grunts._on_player_attack(1)
	animation_ended = false
	
	animated_sprite.play(animation_name)
	
func _exit(_next_state: String):
	pass
	
func state_guard(next_state) -> bool:
	if next_state == "Attack2" or next_state == "Attack3":
		return true
	else:
		return animation_ended
