extends Node
class_name State

@export var allow_all: bool = true
@export var allowed_states: Array[String] = []
@export var animated_sprite: AnimatedSprite2D
@export var animation_name: String
@export var timer: Timer
@export var audio_stream: AudioStreamPlayer
@export var animation_player: AnimationPlayer
@export var use_state_guard_function: bool = false


var active: bool = false:
	get():
		return active
		
	set(value):
		if value != active:
			active = value

func set_active(value: bool, state_name: String):
	active = value
	if active:
		_enter(state_name)
	else:
		_exit(state_name)

func state_guard(_next_state: String) -> bool:
	return true

func _process(delta: float) -> void:
	if active:
		_update(delta)

func _update(delta: float):
	pass
	
func _enter(previous_state: String):
	pass
	
func _exit(next_state: String):
	pass
