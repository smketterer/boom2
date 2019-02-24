extends KinematicBody

var hp = 10
var path = PoolVector3Array([])

onready var console = get_tree().get_root().get_node("Main/ViewportContainer/Viewport/Console")
onready var nav = get_node("../../Navigation")

func get_path(start, end):
	return nav.get_simple_path(start, end, false)

func follow():
	var path_begin = self.get_global_transform().origin
	if path.size() == 0:
		var player = get_node("../../FirstPersonController")
		var path_end = player.get_global_transform().origin
		path = self.get_path(path_begin, path_end)
		path.remove(0)
		return
	else:
		var path_to = path[0] - path_begin
		self.move_and_slide(path_to.normalized() * .5, Vector3(0,1,0))
		if path_to.length() < .25:
			console.log(self, path)
			path.remove(0)
		return

func _process(delta):
	self.follow()

func damage(damage, transform):
	# print(self.get_global_transform().origin)
	# path_begin = self.get_global_transform().origin
	# path_end = Vector3(5,0,7)
	# print(self.move_to(path_begin, path_end))
	if console:
		console.log(self, "Hit for %s damage" % damage)
	hp -= damage
	if hp <= 0:
		self.die()

func die():
	self.queue_free()
