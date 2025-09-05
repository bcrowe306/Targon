extends State
@onready var health_node: HealthNode = $"../../HealthNode"
@onready var damage_player: AudioStreamPlayer = $"../../DamagePlayer"
@onready var new_player: CharacterBody2D = $"../.."
@onready var recover_timer: Timer = $"../../RecoverTimer"

func _ready() -> void:
	recover_timer.timeout.connect(self.on_recover_timeout)

func _enter(_prev: String):
	timer.start()
	damage_player.playSound()
	animated_sprite.play(animation_name)
	health_node.INVINSIBLE = true

func _exit(next_state: String):
	print("Recovering")
	recover_timer.start()

func state_guard(_next_state: String) -> bool:
	return timer.is_stopped()

func on_recover_timeout():
	print("Recovered")
	health_node.INVINSIBLE = false
