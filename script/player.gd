extends CharacterBody2D

enum PLAYER_DIRECTION {LEFT, RIGHT}
var PLAYER_WALK = false
var PLAYER_SHOOT = false

const SPEED = 64.0
const TURN_SPEED = 2
const ROTATE_SPEED = 20
const NITRO_SPEED = 130
var HEALTH:int = 50
var HEALTH_NOW:int = HEALTH

signal health_signal(health:int, healthnow:int)
signal death_signal(isTrue:bool)

var direction := Vector2.RIGHT
var player_direction : PLAYER_DIRECTION = PLAYER_DIRECTION.LEFT

func change_direction(new_direction: PLAYER_DIRECTION):
	player_direction = new_direction

@onready var weapon: Weapon = $Weapon as Weapon
@onready var animation_player: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	emit_signal("health_signal", HEALTH , HEALTH_NOW)
	animation_player.play("idle")
	
func _physics_process(delta: float):
	# Dapatkan batas layar (Rect2) dalam koordinat global
	var viewport_rect = get_viewport_rect()
	var input_direction := Input.get_vector("turn_left", "turn_right", "turn_up", "turn_down")
	var velocity = Vector2.ZERO  # Inisialisasi kecepatan
	var current_speed = SPEED
	if input_direction.x != 0:
		if Input.is_action_pressed("turn_left"):
			animation_player.flip_h = input_direction.x < 0  # Membalik sprite jika bergerak ke kiri
			change_direction(PLAYER_DIRECTION.LEFT)
			position.x -= 5
			animation_player.play("walk")	
			PLAYER_WALK = true
		if Input.is_action_pressed("turn_right"):
			animation_player.flip_h = input_direction.x < 0
			change_direction(PLAYER_DIRECTION.RIGHT)
			position.x += 5
			animation_player.play("walk")
			PLAYER_WALK = true
		velocity = direction.normalized() * (input_direction.x + 100) * current_speed
	else :
		velocity = Vector2.ZERO
		if ["turn_left", "turn_right", "shoot"].any(Input.is_action_just_released):
			animation_player.play("idle")
			PLAYER_SHOOT = false
		if Input.is_action_just_pressed("reload"):
			animation_player.play("reload")
			await get_tree().create_timer(0.5).timeout
			animation_player.play("idle")
		if Input.is_action_just_pressed("shoot"):
			print("ok")
			await get_tree().create_timer(1).timeout
		if Input.is_action_pressed("shoot"):
			animation_player.play("shoot")
			PLAYER_SHOOT = true
			weapon.fire()
		PLAYER_WALK = false
	
	# Batasi posisi player agar tetap di dalam layar
	position.x = clamp(position.x, viewport_rect.position.x-525, viewport_rect.position.x + viewport_rect.size.x - 600)
	position.y = clamp(position.y, viewport_rect.position.y, viewport_rect.position.y + viewport_rect.size.y)
	
	move_and_slide()

func _input(event):
	if event.is_action_pressed("shoot"):
		weapon.fire()


func _on_player_health_signal(health: int, healthnow: int) -> void:
	pass # Replace with function body.
