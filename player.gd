extends CharacterBody2D

@export var speed: float = 250.0
@export var gravity_strength: float = 980.0
@export var jump_velocity: float = 400.0
@export var rotation_speed: float = 8.0

@onready var camera_2d: Camera2D = $Camera2D
@onready var pivot: Node2D = $"../Pivot"
@onready var tile: TileMapLayer = $"../Pivot/TileMapLayer"

var gravity_dir: Vector2 = Vector2.DOWN
var target_rotation: float = 0.0

func _physics_process(delta: float) -> void:
	# Change gravity direction
	

		
	if Input.is_action_just_pressed("ui_up"):
		pivot.position = position
		target_rotation = pivot.rotation + PI
	elif Input.is_action_just_pressed("ui_left"):
		target_rotation = pivot.rotation - PI / 2.0
	elif Input.is_action_just_pressed("ui_right"):
		target_rotation = pivot.rotation + PI / 2.0

	pivot.rotation = lerp_angle(
		pivot.rotation,
		target_rotation,
		rotation_speed * delta
	)

	# Apply gravity
	velocity += gravity_dir * gravity_strength * delta

	# Get WASD input
	var input_dir = 0
	if Input.is_key_pressed(KEY_A):
		input_dir -= 1.0
	if Input.is_key_pressed(KEY_D):
		input_dir += 1.0
		
	# Rotate character to match gravity
	
	rotation = lerp_angle(
		rotation,
		target_rotation,
		rotation_speed * delta
	)


	# Movement relative to gravity
	var up_dir := -gravity_dir
	var right_dir := Vector2(-up_dir.y, up_dir.x)

 # Preserve velocity along gravity
	var gravity_velocity := gravity_dir * velocity.dot(gravity_dir)
	velocity = gravity_velocity + right_dir * input_dir * speed

	# Jump opposite to gravity
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity = velocity.slide(right_dir)
		velocity += up_dir * jump_velocity

	move_and_slide()
