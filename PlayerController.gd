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
export var gravity = 0.5

export var ammo_9mm = 50
export var ammo_shells = 12

var acceleration = Vector3(walk_speed, jump_speed, walk_speed)
var velocity = Vector3(0,0,0)
var max_speed = max_walk_speed
var current_time = 0
var next_weapon

onready var weapon = get_node("Camera/Weapon")
onready var current_weapon = weapon.get_node('Pistol')
onready var anim = current_weapon.get_node('AnimationPlayer')
onready var ray = current_weapon.get_node('RayCast')

onready var console = get_tree().get_root().get_node("Main/ViewportContainer/Viewport/Console")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_process(true)

func _process(delta):
	current_time += delta

	var bob_h = cos(current_time / deg2rad(20)) * abs(velocity.length() / max_walk_speed) * 32
	var bob_v = sin(current_time / deg2rad(10)) * abs(velocity.length() / max_walk_speed) * 16
	weapon.position.x = bob_h
	weapon.position.y = bob_v

	if Input.is_action_pressed("SHOOT") and not anim.is_playing():
		self.shoot()

	if exit_on_escape:
		if Input.is_key_pressed(KEY_ESCAPE):
			get_tree().quit()

	if Input.is_key_pressed(KEY_1) and not anim.is_playing() and not current_weapon.name == 'Pistol':
		switch_weapon('Pistol')

	if Input.is_key_pressed(KEY_2) and not anim.is_playing() and not current_weapon.name == 'ChainGun':
		switch_weapon('ChainGun')

	if Input.is_key_pressed(KEY_3) and not anim.is_playing() and not current_weapon.name == 'Shotgun':
		switch_weapon('Shotgun')

func switch_weapon(weapon_node):
	current_weapon.get_node('AnimationPlayer').play('Holster')
	next_weapon = weapon_node

func shoot():
	anim.play('Shoot')
	ray = current_weapon.get_node('RayCast')
	console.log(self, ray)
	console.log(self, ray.rotation)
	console.log(self, self.get_node("Camera").rotation)
	ray.force_raycast_update()
	if ray.is_colliding():
			var body = ray.get_collider()
			if body.has_method("damage"):
					body.damage(5, ray.global_transform)

func _on_AnimationPlayer_animation_finished(animation):
	console.log(self, "Animation stopped %s" % animation)
	console.log(self, "Current weapon %s" % current_weapon.name)
	if animation == "Holster":
		current_weapon.visible = false
		current_weapon = weapon.get_node(next_weapon)
		current_weapon.visible = true
		anim = current_weapon.get_node('AnimationPlayer')
		anim.play('Draw')
	if animation == "Shoot":
		if Input.is_key_pressed(KEY_1) and not current_weapon.name == 'Pistol':
			switch_weapon('Pistol')
			return
		if Input.is_key_pressed(KEY_2) and not current_weapon.name == 'ChainGun':
			switch_weapon('ChainGun')
			return
		if Input.is_action_pressed("SHOOT"):
			self.shoot()
			return

func _physics_process(delta):
	velocity.y -= gravity

	if Input.is_key_pressed(KEY_SHIFT) and is_on_floor():
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
		ray.rotate_y(-sensitivity_x * event.relative.x)
