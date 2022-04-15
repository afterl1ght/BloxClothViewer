extends LineEdit

class_name HexColEdit

var parent : ColorPlate

var hexlen : int = 6
var previous : String = "FFFFFF"

var text_changing = false

var afterready = false
var prevent_enable_input = false

func _ready():
	parent = get_parent()
	
	connect("text_changed", self, "text_changed")
	if parent:
		parent.connect("on_color_changed", self, "sync_color")

func is_valid(txt : String):
	if txt.length() > hexlen:
		return false
	elif txt.length() <= 0:
		return true
	
	return txt.is_valid_hex_number(false)
	
func fill_blank(txt : String) -> String:
	var diff = hexlen - txt.length()
	if diff > 0:
		var filler = ""
		for _i in diff:
			filler += "f"
		return txt + filler
		
	return txt

func sync_color(col : Color):
	if !text_changing:
		text = col.to_html(false)
		previous = text

func isWithinRect(pos, tolerance = 1):
	return (rect_global_position.x < pos.x) and (rect_global_position.y < pos.y) and (rect_global_position.x + rect_size.x > pos.x) and (rect_global_position.y + rect_size.y > pos.y)

var enable_input_check = false

func _unhandled_input(event):
	if enable_input_check:
		if event and (event is InputEventScreenTouch and event.pressed) or event is InputEventScreenDrag:
			release_focus()
			selecting_enabled = false
			enable_input_check = false
			if !is_valid(text):
				text = previous
			
			text = fill_blank(text)
			
func _input(event):
	if event and event is InputEventScreenDrag:
		prevent_enable_input = true
	else:
		prevent_enable_input = false
	
	if event and event is InputEventScreenTouch and event.pressed:
		if !isWithinRect(event.position) and enable_input_check:
			release_focus()
			selecting_enabled = false
			enable_input_check = false
			if !is_valid(text):
				text = previous
				
			text = fill_blank(text)
		else:
			if !prevent_enable_input:
				enable_input_check = true
				selecting_enabled = true

func text_changed(newtext):
	text_changing = true
	if !is_valid(newtext):
		editable = false
		var curpos = caret_position-1
		text = previous
		if OS.has_virtual_keyboard():
			OS.show_virtual_keyboard(text)
		caret_position = max(0, min(curpos, text.length()))
		
		editable = true
		previous = text
	else:
		previous = newtext
	
	var designatedColor : Color = Color(fill_blank(text))
	parent.set_color_to_wheel(designatedColor)
	parent.selectedColor = designatedColor
	
	print(text)
	text_changing = false
	
func _process(_delta):
	if !afterready:
		afterready = true
		text = parent.selectedColor.to_html(false)
		previous = text
	
	# TODO: Change height position when virtual keyboard (non-floating state) exceeds the plate's height
	#int virtualkbheight = OS.get_virtual_keyboard_height()
	#if virtualkbheight > :	
