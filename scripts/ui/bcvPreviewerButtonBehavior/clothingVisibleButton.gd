extends TextureButton

onready var thisParent = get_parent()

func _toggled(button_pressed):
	var targetColor = Color.transparent
	if not button_pressed:
		targetColor = Color.white
		self_modulate = Color.white
	else:
		self_modulate = Color(0.635, 0.635, 0.635, 1)
	
	if thisParent.isShirt:
		thisParent.blockmatshirt.albedo_color = targetColor
	else:
		thisParent.blockmatpantsHybrid.albedo_color = targetColor
		thisParent.blockmatpants.albedo_color = targetColor
