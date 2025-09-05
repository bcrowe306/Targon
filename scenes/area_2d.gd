extends Area2D

@onready var mob_boar_white: CharacterBody2D = $".."

func _process(_delta: float) -> void:
	for body in get_overlapping_bodies():
		if body.is_in_group("Player"):
			body.hit(-mob_boar_white.DAMAGE)

func _on_body_entered(_body: Node2D) -> void:
	pass
	#var state = mob_boar_white.state
	#if body.is_in_group("Player"):
		#body.hit(-mob_boar_white.DAMAGE)
