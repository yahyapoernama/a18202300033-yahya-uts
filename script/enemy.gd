extends Area2D

@export var speed = 2
@onready var animation_enemy: AnimatedSprite2D = $AnimatedSprite2D
@onready var sprite := $AnimatedSprite2D
@onready var collision_enemy: CollisionShape2D = $CollisionShape2D
@onready var player_pos = get_tree().get_root().get_node("MainScene/Player")

const SPEED = 34.0
var HEALTH:int = 2
var HEALTH_NOW:int = HEALTH
const POINT = 1 
const DAMAGE = 1

signal enemy_death

var direction: Vector2 = Vector2.ZERO
var initial_movement: bool = true

func _ready() -> void:	
	animation_enemy.play("walk")
	set_direction_to_center()

func set_direction_to_center():
	var center_position = get_viewport_rect().size / 2
	direction = (center_position - position).normalized()
	
func _process(delta: float) -> void:
	if HEALTH_NOW <= 0:
		return
	if player_pos:
		# Hitung arah ke pemain
		var direction_to_player = (player_pos.global_position - global_position).normalized()
		var distance_to_attack = 75
		if player_pos.position.x > position.x :
			if (player_pos.position.x-position.x) < distance_to_attack :
				animation_enemy.play("attack")
				await get_tree().create_timer(3).timeout
			else :
				animation_enemy.flip_h = false
				animation_enemy.play("walk")
				position.x += speed/2
		elif player_pos.position.x < position.x :
			if (position.x-player_pos.position.x) < distance_to_attack :
				animation_enemy.play("attack")
				await get_tree().create_timer(3).timeout
			else :
				animation_enemy.flip_h = true
				animation_enemy.play("walk")
				position.x -= speed/2
		

func set_random_direction():
	var angle = randf() * TAU
	direction = Vector2(cos(angle), sin(angle)).normalized()  

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group('player-bullet'):
		HEALTH_NOW -= area.DAMAGE
		area.queue_free()

	if HEALTH_NOW <= 0:
		animation_enemy.play("dead")
		collision_enemy.queue_free()
		emit_signal("enemy_death", POINT)
		await animation_enemy.animation_finished
		queue_free()
		
	print(HEALTH_NOW)
