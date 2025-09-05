extends Node2D
@onready var player: CharacterBody2D  = $NewPlayer
@onready var player_spawn: Node2D = $PlayerSpawn
@onready var hud: CanvasLayer = $HUD

func _ready() -> void:
	player.position = player_spawn.position
	update_hud()
	


	
func update_hud():
	hud.set_coins(player.get_coins())
	hud.set_diamonds(player.get_diamonds())

func _on_player_coins(amount: int) -> void:
	hud.set_coins(amount)


func _on_player_diamonds(amount: int) -> void:
	hud.set_diamonds(amount) # Replace with function body.


func _on_new_player_died(_health: float) -> void:
	player.respawn() # Replace with function body.
	player.position = player_spawn.position
	hud.reset()
	update_hud()# Replace with function body.
