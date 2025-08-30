extends Area2D

@onready var swordHitbox := $swordCollisionShape
@onready var playerNode := $".."
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var attack_1_damage: float = -34.0
@export var attack_2_damage: float = -48.0
@export var attack_3_damage: float = -68.0
@export var push_force: float = 1000.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	monitoring = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	pass
	#var force = -(push_force + (playerNode.attack_number * 1000))
	#if playerNode.facing_direction:
		#force = force * -1
	#if body is RigidBody2D:
		#var b :RigidBody2D  = body
		#b.apply_central_impulse(Vector2(1,0) * force)
	#for child in body.get_children():
		#if child is HealthNode:
			#if child.health > 0:
				#if playerNode.attack_number == 0:
					#child.hit(attack_1_damage)
				#elif playerNode.attack_number == 1:
					#child.hit(attack_2_damage)
				#elif  playerNode.attack_number == 2:
					#child.hit(attack_3_damage)

func _on_player_direction_changed(direction: int) -> void:
	if direction > 0:
		swordHitbox.position.x = 28
		collision_shape_2d.position.x = 8.5
		
	elif direction < 0:
		swordHitbox.position.x = -28
		collision_shape_2d.position.x = -8.5


func _on_player_attack(attack_number: int) -> void:
	for body in get_overlapping_bodies():
		var force = -(push_force + (playerNode.attack_number * 1000))
		if playerNode.facing_direction:
			force = force * -1
		if body is RigidBody2D:
			var b :RigidBody2D  = body
			b.apply_central_impulse(Vector2(1,0) * force)
		for child in body.get_children():
			if child is HealthNode:
				if child.health > 0:
					if playerNode.attack_number == 0:
						child.hit(attack_1_damage)
					elif playerNode.attack_number == 1:
						child.hit(attack_2_damage)
					elif  playerNode.attack_number == 2:
						child.hit(attack_3_damage)
