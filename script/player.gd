extends CharacterBody2D

const SPEED = 64.0
const TURN_SPEED = 2
const ROTATE_SPEED = 20
const NITRO_SPEED = 130
var HEALTH:int = 5
var HEALTH_NOW:int = HEALTH

var direction := Vector2.RIGHT

@onready var animation_player: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	print('player')
	animation_player.play("idle")
	
#func _physics_process(delta: float):
	#var velocity = Vector2.ZERO  # Inisialisasi kecepatan
	## Cek input arah kiri dan kanan
	#if Input.is_action_pressed("ui_left"):
		#velocity.x -= SPEED  # Bergerak ke kiri
	#elif Input.is_action_pressed("ui_right"):
		#velocity.x += SPEED  # Bergerak ke kanan
#
	#move_and_slide()
	
func _physics_process(delta: float):
	# Dapatkan batas layar (Rect2) dalam koordinat global
	var viewport_rect = get_viewport_rect()
	var input_direction := Input.get_vector("turn_left", "turn_right", "turn_up", "turn_down")
	var velocity = Vector2.ZERO  # Inisialisasi kecepatan
	var current_speed = SPEED
	if input_direction.x != 0:
		if Input.is_action_pressed("turn_left"):
			animation_player.flip_h = input_direction.x < 0  # Membalik sprite jika bergerak ke kiri
			position.x -= 5
			animation_player.play("walk")	
		if Input.is_action_pressed("turn_right"):
			animation_player.flip_h = input_direction.x < 0
			position.x += 5
			animation_player.play("walk")	
		velocity = direction.normalized() * (input_direction.x + 100) * current_speed
	else :
		velocity = Vector2.ZERO
		if ["turn_left", "turn_right", "shoot"].any(Input.is_action_just_released):
			animation_player.play("idle")	
		if Input.is_action_just_pressed("reload"):
			animation_player.play("reload")
			await get_tree().create_timer(0.5).timeout
			animation_player.play("idle")
		if Input.is_action_pressed("shoot"):
			animation_player.play("shoot")
	
	# Batasi posisi player agar tetap di dalam layar
	position.x = clamp(position.x, viewport_rect.position.x-525, viewport_rect.position.x + viewport_rect.size.x - 600)
	position.y = clamp(position.y, viewport_rect.position.y, viewport_rect.position.y + viewport_rect.size.y)
	
	move_and_slide()