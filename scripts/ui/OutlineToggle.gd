extends TextureButton

var outlineEnabled = false

func _ready():
	if outlineEnabled:
		modulate.a = 1
	else:
		modulate.a = 0.25

func _pressed():
	outlineEnabled = !outlineEnabled
	Preloader.outlinemat.set_shader_param("enable", outlineEnabled)
	if outlineEnabled:
		modulate.a = 1
	else:
		modulate.a = 0.25
