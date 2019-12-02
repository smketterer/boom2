extends KinematicBody

export var hp = 10
export var speed = 4
var path = PoolVector3Array([])

onready var console = get_tree().get_root().get_node("Main/ViewportContainer/Viewport/Console")
onready var nav = get_node("../../Navigation")


func follow():
	var path_begin = self.get_global_transform().origin
	if path.size() == 0:
		var player = get_node("../../FirstPersonController")
		var path_end = player.get_global_transform().origin
		path = PoolVector3Array([])
		path = nav.get_simple_path(path_begin, path_end, false)
		path.remove(0)
		# Check for path distance to prevent jiggle at the end.
		# CODE GOES HERE
	else:
		var path_to = path[0] - path_begin
		if path_to.length() > 1:
			self.move_and_slide(path_to.normalized() * speed, Vector3(0,1,0))
		else:
			path.remove(0)

func _process(delta):
	self.follow()

func damage(damage, transform):
	if console:
		console.log(self, "Hit for %s damage" % damage)
	hp -= damage
	if hp <= 0:
		self.die()

func die():
	self.queue_free()
