extends KinematicBody

export var hp = 10
export var speed = 7
var path = PoolVector3Array([])

onready var console = get_tree().get_root().get_node("Main/ViewportContainer/Viewport/Console")
onready var nav = get_node("../../Navigation")

var m = SpatialMaterial.new()

func _ready():
	m.flags_unshaded = true
	m.flags_use_point_size = true
	m.albedo_color = Color.white

func follow():
	var current_position = self.get_global_transform().origin
	
	var im = get_node("../Draw")
	im.set_material_override(m)
	im.clear()
	im.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
	for x in path:
		im.add_vertex(x)
	im.end()
	
	if path.size() < 5:
		path = PoolVector3Array([])
		var player_position = get_node("../../FirstPersonController").get_global_transform().origin
		path = nav.get_simple_path(current_position, player_position, true)
		path.remove(0)
	else:
		var to = path[1] - current_position
		if to.length() < .05:
			path.remove(0)
		else:
			self.move_and_slide(to.normalized() * speed, Vector3(0,1,0))


func _process(_delta):
	self.follow()

func damage(damage, _transform):
	if console:
		console.log(self, "Hit for %s damage" % damage)
	hp -= damage
	if hp <= 0:
		self.die()

func die():
	self.queue_free()
