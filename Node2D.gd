extends Node2D

var player
var obstacles = []
var speed = 200
var score = 0
var is_game_over = false
var spawn_timer = 0.0
var spawn_interval = 1.2
var game_over_label
var score_label

func _ready():
	randomize()
	create_player()
	create_labels()
	set_process(true)

func create_player():
	player = ColorRect.new()
	player.color = Color(0, 0.8, 1)  # Bright blue
	player.size = Vector2(50, 50)
	player.position = Vector2(get_viewport().size.x / 2 - 25, get_viewport().size.y - 70)
	add_child(player)

func create_labels():
	score_label = Label.new()
	score_label.text = "Score: 0"
	score_label.position = Vector2(10, 10)
	add_child(score_label)

	game_over_label = Label.new()
	game_over_label.text = ""
	game_over_label.visible = false
	game_over_label.position = Vector2(get_viewport().size.x / 2 - 100, get_viewport().size.y / 2 - 20)
	add_child(game_over_label)

func _process(delta):
	if is_game_over:
		return

	handle_input(delta)
	spawn_timer += delta
	if spawn_timer >= spawn_interval:
		spawn_timer = 0
		spawn_obstacle()

	move_obstacles(delta)
	check_collisions()

func handle_input(delta):
	if Input.is_key_pressed(KEY_A):
		player.position.x -= speed * delta
	elif Input.is_key_pressed(KEY_D):
		player.position.x += speed * delta

	# Keep player within screen bounds
	player.position.x = clamp(player.position.x, 0, get_viewport().size.x - player.size.x)

func spawn_obstacle():
	var obs = ColorRect.new()
	obs.color = Color(1, 0, 0)  # Red
	obs.size = Vector2(40, 40)
	var x_pos = randf_range(0, get_viewport().size.x - obs.size.x)
	obs.position = Vector2(x_pos, -40)
	add_child(obs)
	obstacles.append(obs)

func move_obstacles(delta):
	for obs in obstacles:
		obs.position.y += 150 * delta
	obstacles = obstacles.filter(func(o):
		if o.position.y > get_viewport().size.y:
			o.queue_free()
			score += 1
			score_label.text = "Score: %d" % score
			return false
		return true
	)

func check_collisions():
	for obs in obstacles:
		if player.get_global_rect().intersects(obs.get_global_rect()):
			game_over()

func game_over():
	is_game_over = true
	game_over_label.text = "GAME OVER\nFinal Score: %d" % score
	game_over_label.visible = true




