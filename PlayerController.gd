extends KinematicBody

export var Sensitivity_X = 0.01
export var Sensitivity_Y = 0.0025
export var Invert_Y_Axis = false
export var Exit_On_Escape = true
export var Maximum_Y_Look = 45
export var Accelaration = 10.0
export var Maximum_Walk_Speed = 2.5
export var Jump_Speed = 5.0

const GRAVITY = 0.098
var velocity = Vector3(0,0,0)
var speed = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_process(true)

func _process(delta):
	if Exit_On_Escape:
		if Input.is_key_pressed(KEY_ESCAPE):
			get_tree().quit()

func _physics_process(delta):
	velocity.y -= GRAVITY

	if Input.is_action_pressed('MOVE_FORWARD') or Input.is_action_pressed('MOVE_BACKWARD') or Input.is_action_pressed('MOVE_LEFT') or Input.is_action_pressed('MOVE_RIGHT'):
		speed += Accelaration
		if speed > Maximum_Walk_Speed:
			speed = Maximum_Walk_Speed

	if Input.is_action_pressed('MOVE_FORWARD'):
		velocity.x = -global_transform.basis.z.x * speed
		velocity.z = -global_transform.basis.z.z * speed
	if Input.is_action_pressed('MOVE_BACKWARD'):
		velocity.x = global_transform.basis.z.x * speed
		velocity.z = global_transform.basis.z.z * speed
	if Input.is_action_pressed('MOVE_LEFT'):
		velocity.x = -global_transform.basis.x.x * speed
		velocity.z = -global_transform.basis.x.z * speed
	if Input.is_action_pressed('MOVE_RIGHT'):
		velocity.x = global_transform.basis.x.x * speed
		velocity.z = global_transform.basis.x.z * speed

	if not(Input.is_action_pressed('MOVE_FORWARD') or Input.is_action_pressed('MOVE_BACKWARD') or Input.is_action_pressed('MOVE_LEFT') or Input.is_action_pressed('MOVE_RIGHT')):
		speed = 0
		velocity.x = 0
		velocity.z = 0

	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = Jump_Speed

	velocity = move_and_slide(velocity, Vector3(0,1,0))

# Rotate X
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-Sensitivity_X * event.relative.x)
