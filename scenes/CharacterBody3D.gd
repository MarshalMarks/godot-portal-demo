extends CharacterBody3D

@export var gravity = 50.0
@export var speed = 10.0
@export var jump_velocity = 15.0
@export var slowdown_multiplier = 100.0

@export var mouse_sensitivity: float = 0.002

@onready var head = $Head
@onready var camera = $Head/Camera3D

var camera_rotation_x: float = 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity) # Horizontal rotation of player
		camera_rotation_x += -event.relative.y * mouse_sensitivity
		camera_rotation_x = clamp(camera_rotation_x, deg_to_rad(-90), deg_to_rad(90))
		head.rotation.x = camera_rotation_x

func _physics_process(delta):
	# gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = Vector3(input_dir.x, 0, input_dir.y).rotated(Vector3(0,1,0), self.global_rotation.y).normalized()
	print(self.global_rotation.y)
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, slowdown_multiplier * delta)
		velocity.z = move_toward(velocity.z, 0, slowdown_multiplier * delta)

	# handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	move_and_slide()
