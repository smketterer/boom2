extends RigidBody

var hp = 10

onready var console = get_tree().get_root().get_node("Main/ViewportContainer/Viewport/Console")

func damage(damage, transform):
	if console:
		console.log(self, "Hit for %s damage" % damage)
	hp -= damage
	if hp <= 0:
		self.die()

func die():
	self.queue_free()
