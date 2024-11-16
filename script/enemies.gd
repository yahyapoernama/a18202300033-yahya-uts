extends Area2D

@export var speed = 2
@onready var animation_player: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite := $AnimatedSprite2D
@onready var player_pos = get_tree().get_root().get_node("MainScene/Player")
#@onready var direction_change_timer: Timer = $Timer2

var player: CharacterBody2D

const SPEED = 34.0
var HEALTH:int = 2
var HEALTH_NOW:int = HEALTH
const POINT = 1 
const DAMAGE = 1

signal enemy_death

var direction: Vector2 = Vector2.ZERO
var initial_movement: bool = true

func _ready() -> void:	
	#player = get_tree().get_root().get_node("MainScene/Player") as CharacterBody2D  # Adjust the path as necessary
	print(player)
	animation_player.play("walk")
	set_direction_to_center()
	#direction_change_timer.start()

#func point_weapon_to_player() -> void:
	#if player:
		#var direction_to_player = (player.global_position - weapon.global_position).normalized()
		#
		#weapon.rotation = direction_to_player.angle()
		
func set_direction_to_center():
	var center_position = get_viewport_rect().size / 2
	direction = (center_position - position).normalized()
	
func _process(delta: float) -> void:
	#animation_player.play("walk")
	if HEALTH_NOW <= 0:
		return
	if player_pos:
		# Hitung arah ke pemain
		var direction_to_player = (player_pos.global_position - global_position).normalized()
		var distance_to_attack = 75
		# Perbarui posisi musuh
		#print((direction_to_player*speed*delta).x)
		#global_position += Vector2(direction_to_player * speed * delta)
		#print(len(get_tree().get_nodes_in_group('enemy-body')))
		if player_pos.position.x > position.x :
			if (player_pos.position.x-position.x) < distance_to_attack :
				animation_player.play("attack")
				await get_tree().create_timer(3).timeout
			else :
				animation_player.flip_h = false
				animation_player.play("walk")
				position.x += speed/2
		elif player_pos.position.x < position.x :
			if (position.x-player_pos.position.x) < distance_to_attack :
				animation_player.play("attack")
				await get_tree().create_timer(3).timeout
			else :
				animation_player.flip_h = true
				animation_player.play("walk")
				position.x -= speed/2
		#print("player pos : " + str(player_pos.position.x))
		#print("enemies pos : " + str(position.x))
	#position.x -= speed
		

func set_random_direction():
	var angle = randf() * TAU
	direction = Vector2(cos(angle), sin(angle)).normalized()  

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group('player-bullet'):
		#print("damage", area.DAMAGE)
		HEALTH_NOW -= area.DAMAGE
		area.queue_free()

	if HEALTH_NOW <= 0:
		emit_signal("enemy_death", POINT)
		animation_player.play("dead")
		await animation_player.animation_finished
		queue_free()
		
