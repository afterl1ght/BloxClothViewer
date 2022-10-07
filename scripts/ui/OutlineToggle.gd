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
	if postfxoutline:
		print("e: ", outlineEnabled)
		postfxoutline.visible = outlineEnabled
	else:
		postfxoutline = uimain.postFXOutline
		if postfxoutline:
			print("e: ", outlineEnabled)
			postfxoutline.visible = outlineEnabled
	
	if outlineEnabled:
		modulate.a = 1
	else:
		modulate.a = 0.25
