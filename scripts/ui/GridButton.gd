extends TextureButton

export(NodePath) var uiMainPath
onready var uiMain : UIMain = get_node(uiMainPath)

var isPressed = false
var gridEnabled = true

var gridsquare : MeshInstance

func _pressed():
	isPressed = true
	if !gridEnabled:
		modulate.a = 1
	else:
		modulate.a = 0.25

func _process(dt):
	var justSwitched = false
	if isPressed:
		justSwitched = true
		isPressed = false
		gridEnabled = !gridEnabled
		
	if !uiMain:
		return
	else:
		if !gridsquare:
			if !uiMain.skinModel:
				return
			
			gridsquare = uiMain.skinModel.get_node("SkinMain/gridsquare")
			if !gridsquare:
				return
					
		
	gridsquare.visible = gridEnabled
