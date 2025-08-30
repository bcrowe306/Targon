extends Area2D

@onready var mob_boar_white: CharacterBody2D = $".."

func _on_body_entered(body: Node2D) -> void:
	var state = mob_boar_white.state
	for child in body.get_children():
		if child is HealthNode:
			if child.health > 0:
				var enemy_health_after = child.hit(-mob_boar_white.DAMAGE)
