extends ColorPlateCompat

export(NodePath) var uiMainPath
onready var uiMain : UIMain = get_node(uiMainPath)

func do_post_ready():
	if uiMain:
		if uiMain.directionalLight:
			set_color_to_wheel(uiMain.directionalLight.light_color)
			self.selectedColor = uiMain.directionalLight.light_color

func set_color(val):
	.set_color(val)
	if uiMain:
		if uiMain.directionalLight:
			uiMain.directionalLight.light_color = selectedColor
