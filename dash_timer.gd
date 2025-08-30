extends Timer
signal dash()

var counter:int = 0
var last_direction: int = 0

func direction_input(direction: int):
	if direction != 0:
		if last_direction == 0:
			last_direction = direction
			start()
			
		else:
			if last_direction == direction:
				if not is_stopped():
					dash.emit()
					last_direction = 0
				else:
					last_direction = 0
			else:
				last_direction = direction
				start()
					
