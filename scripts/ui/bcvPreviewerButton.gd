extends TextureButton

class_name BCVPreviewerButton

export(bool) var sinkButtonOnTap = true
var initialScale = rect_scale
var scaleDifferenceOnTap = 0.1
var pressing = false

export(NodePath) var uiMainPath
onready var uiMain : UIMain = get_node(uiMainPath)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_dt):
	if is_pressed() and not pressing:
		pressing = true
		initialScale = rect_scale
		rect_scale.x = initialScale.x - scaleDifferenceOnTap
		rect_scale.y = initialScale.y - scaleDifferenceOnTap
	elif not is_pressed():
		rect_scale = initialScale
		pressing = false
	pass
