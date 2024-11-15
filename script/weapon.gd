extends Node2D
class_name Weapon

enum STATES {READY, FIRING, RELOADING}

#@export var BULLET_SCENE : PackedScene
@onready var BULLET_SCENE = load("res://scene/bullet.tscn") as PackedScene
@onready var PLAYER_SCENE = load("res://scene/player.tscn") as PackedScene
@onready var reload_timer: Timer = $Timer

var state : STATES = STATES.READY 
var player: Node = null

func _ready() -> void:
	player = get_tree().get_root().get_node("MainScene/Player")  # Sesuaikan path ke player
	pass # Replace with function body.
	
func change_state(new_state: STATES):
	state = new_state
	
func fire():
	if state == STATES.FIRING || state == STATES.RELOADING :
		return
		
	change_state(STATES.FIRING)
	if BULLET_SCENE:
		print('bulletscene')
		var bullet = BULLET_SCENE.instantiate()
		#bullet.direction = Vector2.from_angle(global_rotation)
		#print(player.PLAYER_DIRECTION == player.PLAYER_DIRECTION.LEFT)
		if player.player_direction == player.PLAYER_DIRECTION.LEFT:
			bullet.direction = Vector2(-1, 0)
			bullet.global_position = global_position + Vector2(-50, -20)
		else:
			bullet.direction = Vector2(1, 0)
			bullet.global_position = global_position + Vector2(50, -20)
		bullet.add_to_group('bullet')
		move_to_front()
		get_tree().root.add_child(bullet)
		
	else:
		print("BULLET_SCENE is null! Please set it in the editor.")
		
	change_state(STATES.RELOADING)
	reload_timer.start()
	

func enemy_fire():
	pass
	
func _on_reload_timer_timeout():
	var animation_player = player.get_node('AnimatedSprite2D')
	#animation_player.play("reload")
	change_state(STATES.READY)
