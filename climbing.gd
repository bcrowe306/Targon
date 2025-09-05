extends State
@onready var new_player: CharacterBody2D = $"../.."
@onready var climbing_node: Node = $"../../ClimbingNode"


func _enter(_prev: String):
	animated_sprite.animation = animation_name


func _update(delta: float):
	if Input.is_action_pressed("DIR_UP"):
		climb_up(delta)
		
	elif Input.is_action_pressed("DIR_DOWN"):
		climb_down(delta)
		
	else:
		pause_climbing()
		
func pause_climbing():
	new_player.velocity.y = 0
	animated_sprite.pause()

func climb_up(delta: float):
	if climbing_node.can_climb_up(new_player.facing_direction):
		animated_sprite.play(animation_name, 1, false)
		new_player.velocity.y = -60
		new_player.move_and_slide()
	else:
		pause_climbing()
	
func climb_down(delta: float):
	if climbing_node.can_climb_down(new_player.facing_direction):
		animated_sprite.play(animation_name, 1, true)
		new_player.velocity.y = 60
		new_player.move_and_slide()
	else:
		pause_climbing()
	
