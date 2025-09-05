extends State
@onready var new_player: CharacterBody2D = $"../.."

var default_fps: float = 16.0
var min_fps: float = 5.0

func _update(delta: float):
	var speed_ratio: float = new_player.get_velocity_ratio()
	var fps = lerpf(min_fps, default_fps, speed_ratio)
	if speed_ratio < .6:
		animated_sprite.animation = "Walk"
	else:
		animated_sprite.animation = "Run"
	animated_sprite.sprite_frames.set_animation_speed(animation_name, fps)
	

func get_animation() -> String:
	var speed_ratio: float = new_player.get_velocity_ratio()
	if speed_ratio < .6:
		return "Walk"
	else:
		return "Run"

func _enter(_state_name: String):
	animated_sprite.play(get_animation())
