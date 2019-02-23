extends RigidBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var console = get_tree().get_root().get_node("Main/ViewportContainer/Viewport/Console")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func damage(damage, transform):
	# self.free()
	console.log(self, "Hit.")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
