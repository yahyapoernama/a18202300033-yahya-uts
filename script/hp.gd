extends ProgressBar

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass
	
func _on_player_health_signal(health: int, health_now: int) -> void:
	print('ophs')
	max_value = health
	value = 5
