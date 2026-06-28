extends CharacterBody3D

@export var SPEED: float = 5.0
@export var JUMP_VELOCITY: float = 4.5
@export var MOUSE_SENSITIVITY: float = 0.003

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var cam_base = $CamBase

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		cam_base.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		cam_base.rotation.x = clamp(cam_base.rotation.x, deg_to_rad(-50), deg_to_rad(50))

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("a", "d", "w", "s")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()