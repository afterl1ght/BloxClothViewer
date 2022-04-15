extends TextureButton

export(NodePath) var colorPlatePath
var colorPlate: ColorPlate

var toggled = false

func _ready():
	colorPlate = get_node(colorPlatePath)

func _toggled(button_pressed):
	if colorPlate:
		toggled = button_pressed

		var tween = colorPlate.get_node("Tween")
		if toggled:
			self_modulate = Color(0.635, 0.635, 0.635, 1)
			if tween and (tween is Tween):
				tween.stop_all()
				tween.interpolate_property(colorPlate, "margin_left", colorPlate.margin_left, -252, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
				tween.start()
		else:
			self_modulate = Color(1, 1, 1, 1)
			tween.stop_all()
			tween.interpolate_property(colorPlate, "margin_left", colorPlate.margin_left, 198, 0.5, Tween.TRANS_QUAD, Tween.EASE_IN)
			tween.start()
