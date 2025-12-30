extends CharacterBody2D

signal player_hit_wall
signal player_reached_exit

const SPEED: float = 200.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var can_move: bool = true

func _ready():
	# Set up player appearance
	pass

func _physics_process(delta: float):
	if not can_move:
		return
	
	# Get input direction
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_up") or Input.is_key_pressed(KEY_W):
		direction.y -= 1
	if Input.is_action_pressed("ui_down") or Input.is_key_pressed(KEY_S):
		direction.y += 1
	if Input.is_action_pressed("ui_left") or Input.is_key_pressed(KEY_A):
		direction.x -= 1
	if Input.is_action_pressed("ui_right") or Input.is_key_pressed(KEY_D):
		direction.x += 1
	
	# Normalize for diagonal movement
	if direction.length() > 0:
		direction = direction.normalized()
	
	# Apply movement
	velocity = direction * SPEED
	move_and_slide()

func reset_position(start_pos: Vector2):
	global_position = start_pos
	velocity = Vector2.ZERO

func set_can_move(value: bool):
	can_move = value
	if not value:
		velocity = Vector2.ZERO