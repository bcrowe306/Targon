extends CanvasLayer
@onready var health_bar: ProgressBar = $VBoxContainer/HealthBar
@onready var armor_bar: ProgressBar = $Armor/ArmorBar
@onready var diamonds_label: Label = $VBoxContainer/Diamonds/DiamondsLabel
@onready var coins_label: Label = $VBoxContainer/Coins/CoinsLabel

var high_health_color: String = "60ff52"
var medium_health_color: String = "f5cd05"
var low_health_color: String = "f53505"
var format_string = "x %s"

func set_coins(amount: int):
	coins_label.text = format_string %  str(amount)

func set_diamonds(amount: int):
	diamonds_label.text = format_string %  str(amount)

func _ready() -> void:
	reset()

func setHealthBarPercent(health: float):
	health_bar.value = clamp(health, 0.0, 100.0)
	setHealthBarColor()
	
func reset():
	setHealthBarPercent(100.0)
	setArmorBarPercent(0.0)
	set_coins(0)
	set_diamonds(0)
	
	
func setArmorBarPercent(armor: float):
	armor_bar.value = clamp(armor, 0.0, 100.0)

func _on_player_damaged(health: float, _delta: float) -> void:
	self.setHealthBarPercent(health) # Replace with function body.

func setHealthBarColor():
	var fill_style = health_bar.get("theme_override_styles/fill")
	
	if health_bar.value > 66:
		fill_style.bg_color = high_health_color
	elif health_bar.value > 33:
		fill_style.bg_color = medium_health_color
	else:
		fill_style.bg_color = low_health_color
