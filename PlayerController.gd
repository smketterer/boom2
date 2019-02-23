extends KinematicBody

export var sensitivity_x = 0.01
export var sensitivity_y = 0.0025
export var invert_y_axis = false
export var exit_on_escape = true
export var max_y_look = 45
export var friction = 0.95
export var max_walk_speed = 10.0
export var walk_speed = 1.0
export var max_run_speed = 17.5
export var run_speed = 2.0
export var jump_speed = 10.0

export var GRAVITY = 0.5

var acceleration = Vector3(walk_speed, jump_speed, walk_speed)
var velocity = Vector3(0,0,0)
var max_speed = max_walk_speed
var current_time = 0

onready var anim = get_node('AnimationPlayer')

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_process(true)

func _process(delta):
	current_time += delta

	var weapon = get_node("Weapon")
	var bob_h = cos(current_time / deg2rad(20)) * abs(velocity.length() / max_walk_speed) * 32
	var bob_v = sin(current_time / deg2rad(10)) * abs(velocity.length() / max_walk_speed) * 16
	var weapon_x = 960 + bob_h
	var weapon_y = 936 + bob_v

	weapon.position.x = weapon_x
	weapon.position.y = weapon_y

	if Input.is_action_just_pressed("SHOOT"):
		anim.play('Shoot')

	if exit_on_escape:
		if Input.is_key_pressed(KEY_ESCAPE):
			get_tree().quit()

func _on_AnimationPlayer_animation_finished(animation):
	if animation == 'Shoot':
		anim.stop()

func _physics_process(delta):
	velocity.y -= GRAVITY

	if Input.is_key_pressed(KEY_SHIFT):
		acceleration = Vector3(run_speed, jump_speed, run_speed)
		max_speed = max_run_speed
		# get_node("Camera").fov = 65
	else:
		acceleration = Vector3(walk_speed, jump_speed, walk_speed)
		max_speed = max_walk_speed
		# get_node("Camera").fov = 70

	if Input.is_action_pressed('MOVE_FORWARD'):
		velocity.x += -global_transform.basis.z.x * acceleration.x
		velocity.z += -global_transform.basis.z.z * acceleration.z
	if Input.is_action_pressed('MOVE_BACKWARD'):
		velocity.x += global_transform.basis.z.x * acceleration.x
		velocity.z += global_transform.basis.z.z * acceleration.z
	if Input.is_action_pressed('MOVE_LEFT'):
		velocity.x += -global_transform.basis.x.x * acceleration.x
		velocity.z += -global_transform.basis.x.z * acceleration.z
	if Input.is_action_pressed('MOVE_RIGHT'):
		velocity.x += global_transform.basis.x.x * acceleration.x
		velocity.z += global_transform.basis.x.z * acceleration.z

	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			velocity.y = acceleration.y

	# Apply friction and cap speeds.
	velocity.x *= friction
	velocity.z *= friction

	# Store the current y velocity so we can restore it later.
	var vy = velocity.y
	velocity.y = 0
	# Now with just the x and z axis in the velocity apply the speed limitation.
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
	# Then restore the y component of the velocity, which will be unrestricted.
	velocity.y = vy

	velocity = move_and_slide(velocity, Vector3(0,1,0))

# Rotate X
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-sensitivity_x * event.relative.x)
