extends Control

class_name EdutorButtons

const BCVEditorButtons = Globals.BCVEditorButtons

export(Array, NodePath) var editorButtonPaths
var editorButtons = {} # contains EditorButtonBehavior objects

# button switcher
var currentButton = BCVEditorButtons.NONE

func _ready():
	for i in range(0, editorButtonPaths.size()):
		editorButtons[i] = get_node(editorButtonPaths[i]);
		editorButtons[i].connect("on_press", self, "changeCurrentButton")
		
	updateButtons()

func setDisableAll():
	setEnableIndex(-1)
	
func setEnableIndex(index):
	for i in range(0, editorButtons.size()):
		if i == index:
			editorButtons[i].setEnable()
			continue
		editorButtons[i].setDisable()

func updateButtons():
	match currentButton:
		BCVEditorButtons.CLOTHING:
			setEnableIndex(0)
		BCVEditorButtons.LIGHTING:
			setEnableIndex(1)
		BCVEditorButtons.BACKGROUND:
			setEnableIndex(2)
			
		_, BCVEditorButtons.NONE:
			setDisableAll()
		

func changeCurrentButton(button):
	if currentButton == button:
		currentButton = BCVEditorButtons.NONE
	else:
		currentButton = button
	
	updateButtons()
