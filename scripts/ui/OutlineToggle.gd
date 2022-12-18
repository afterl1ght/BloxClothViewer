extends TextureButton

export(NodePath) var uimainpath
onready var uimain = get_node(uimainpath)

var postfxoutline = null
var outlineEnabled = false

func _ready():
	if outlineEnabled:
		modulate.a = 1
	else:
		modulate.a = 0.25

func _pressed():
	outlineEnabled = !outlineEnabled
	print("e: ", outlineEnabled)
	if (!outlineEnabled):
		Preloader.outlinemat.set_shader_param("outline_color", Color.transparent)
	else:
		Preloader.outlinemat.set_shader_param("outline_color", Color.black)
	
	if outlineEnabled:
		modulate.a = 1
	else:
		modulate.a = 0.25
