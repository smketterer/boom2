extends RichTextLabel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func log(instance, text):
	var timeDict = OS.get_time();
	var hour = timeDict.hour;
	var minute = timeDict.minute;
	var seconds = timeDict.second;
	var fmt = "[%02d:%02d:%02d] %s: %s"
	var string = fmt % [hour, minute, seconds, instance.name, text]
	self.add_text(string)
	self.newline()
