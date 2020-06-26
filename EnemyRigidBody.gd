extends KinematicBody

export var hp = 10
export var speed = 7
var path = PoolVector3Array([])

onready var console = get_tree().get_root().get_node("Main/ViewportContainer/Viewport/Console")
onready var nav = get_node("../../Navigation")

func _process(_delta):
	pass

func damage(damage, _transform):
	if console:
		console.log(self, "Hit for %s damage" % damage)
	hp -= damage
	if hp <= 0:
		self.die()

func die():
	self.queue_free()
