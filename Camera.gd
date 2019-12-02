extends Camera

var INVERSION_MULT = 1

func _ready():
	if self.get_parent().invert_y_axis:
		INVERSION_MULT = 1
	else:
		INVERSION_MULT = -1
	pass

func _input(event):
	if event is InputEventMouseMotion:
		if INVERSION_MULT * self.get_parent().sensitivity_y * event.relative.y >= 0 and self.rotation_degrees.x >= self.get_parent().max_y_look:
			return
		if INVERSION_MULT * self.get_parent().sensitivity_y * event.relative.y <= 0  and self.rotation_degrees.x <= -self.get_parent().max_y_look:
			return
		rotate_x(INVERSION_MULT * self.get_parent().sensitivity_y * event.relative.y)
