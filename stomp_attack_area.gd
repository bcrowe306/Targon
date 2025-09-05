extends Area2D
@onready var player: CharacterBody2D = $".."

@export var STOMP_ATTACK_DAMAGE: float = 50.0

signal stomp(dead: bool)


func _ready() -> void:
	monitoring = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	for child in body.get_children():
		if child is HealthNode:
			if child.health > 0:
				var enemy_health_after = child.hit(-STOMP_ATTACK_DAMAGE)
				stomp.emit(enemy_health_after <= 0)
				#player.state_machine.state = "Jump2"
				player.do_jump()
