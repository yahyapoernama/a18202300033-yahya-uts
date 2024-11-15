extends Node2D

var ENEMY = preload("res://scene/enemies.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print('start')
	spawnEnemy()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
#	
#func _on_area_2d_area_exited(area: Area2D) -> void:
	#if !area.is_in_group('tank'):
		#print('cleared: ', area.name)
		#area.queue_free()

func spawnEnemy():
	print('spawn enemy')
	var enemy = ENEMY.instantiate()
	enemy.scale = Vector2(1.88, 1.88)
	#enemy.flip_h = !enemy.flip_h
	enemy.add_to_group('enemy-body')

	# Mendapatkan ukuran viewport
	var viewport_size = get_viewport().size

	# Pilih secara acak sisi mana yang akan menjadi tempat spawn
	var side = randi() % 2  # 0: atas, 1: kanan, 2: bawah, 3: kiri

	match side:
		0: # Kiri
			enemy.position = Vector2(-620, 213)
		1: # Kanan
			enemy.position = Vector2(620, 213)

	add_child(enemy)

func _on_timer_timeout() -> void:
	var enemy_count = (len(get_tree().get_nodes_in_group('enemy-body')))
	if enemy_count <= 10 :
		spawnEnemy()
