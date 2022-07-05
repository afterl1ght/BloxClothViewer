extends TextureButton

onready var thisParent = get_parent()

func _toggled(button_pressed):
	var targetAlpha = 0
	if not button_pressed:
		targetAlpha = 1
		self_modulate = Color.white
	else:
		self_modulate = Color(0.635, 0.635, 0.635, 1)
	
	if thisParent.isShirt:
		thisParent.blockmatshirt.set_shader_param("alpha", targetAlpha)
		thisParent.blockmatClothing.set_shader_param("alpha_shirt", targetAlpha)
	else:
		thisParent.blockmatClothing.set_shader_param("alpha_pants", targetAlpha)
		thisParent.blockmatpants.set_shader_param("alpha", targetAlpha)
