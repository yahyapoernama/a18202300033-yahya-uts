extends ProgressBar

var AMMO:int = 0

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	pass
	
func _on_weapon_ammo_signal(ammo: int, ammo_now: int) -> void:
	max_value = ammo
	value = ammo_now


func _on_main_scene_child_entered_tree(node: Node) -> void:
	pass # Replace with function body.
