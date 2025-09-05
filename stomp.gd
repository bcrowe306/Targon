extends State
@onready var new_player: CharacterBody2D = $"../.."
@onready var stomp_particles: CPUParticles2D = $"../../StompParticles"
@onready var stomp_attack_area: Area2D = $"../../StompAttackArea"


func _enter(_state_name: String):
	stomp_attack_area.monitoring = true
	stomp_particles.emitting = true
	audio_stream.play()
	new_player.gravity_multiplier = 3.5
	animated_sprite.play(animation_name)

func _exit(_next_state: String):
	print("Exiting stomp")
	stomp_attack_area.monitoring = false
	stomp_particles.emitting = false
	new_player.gravity_multiplier = 1
