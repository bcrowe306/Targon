extends Area2D

@export var TUMBLE_ATTACK_DAMAGE: float = 50.0
signal tumbled(dead: bool)

func _on_body_entered(body: Node2D) -> void:
	for child in body.get_children():
		if child is HealthNode:
			if child.health > 0:
				var enemy_health_after = child.hit(-TUMBLE_ATTACK_DAMAGE)
				tumbled.emit(enemy_health_after <=0)


func _on_ready() -> void:
	monitoring = false # Replace with function body.
