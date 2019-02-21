extends Camera

const SENSITIVITY_Y = 0.01
const INVERSION_MULT = 1
const MAX_Y = 89

func initializeComponents():
	SENSITIVITY_Y = self.get_parent().sensitivity_y
	MAX_Y = self.get_parent().max_y_look
	if self.get_parent().invert_y_axis:
		INVERSION_MULT = 1
	else:
		INVERSION_MULT = -1

func _ready():
	self.initializeComponents()
	pass

func _input(event):
	if event is InputEventMouseMotion:
		if INVERSION_MULT * SENSITIVITY_Y * event.relative.y >= 0 and self.rotation_degrees.x >= MAX_Y:
			return
		if INVERSION_MULT * SENSITIVITY_Y * event.relative.y <= 0  and self.rotation_degrees.x <= -MAX_Y:
			return
		rotate_x(INVERSION_MULT * SENSITIVITY_Y * event.relative.y)
