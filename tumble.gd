extends State
@onready var new_player: CharacterBody2D = $"../.."
@onready var tumble_attack: Area2D = $"../../TumbleAttack"

func _ready() -> void:
	animated_sprite.animation_finished.connect(self.on_animation_finished)
	timer.timeout.connect(self.on_timout)

func _enter(_state_name: String):
	tumble_attack.monitoring = true
	new_player.SPEED_BOOST = 1.5
	animated_sprite.play("TumbleStart")
	timer.start()

func _exit(next_state: String):
	tumble_attack.monitoring = false

func on_animation_finished():
	if animated_sprite.animation == "TumbleStart":
		animated_sprite.play(animation_name)
		

func on_timout():
	new_player.SPEED_BOOST = 1.0
	new_player.state_machine.state = "Run"
