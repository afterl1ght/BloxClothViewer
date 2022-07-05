extends Control

# This actually manages the whole coloring system unlike their parent
class_name WheelColor

var isDragging = false
var targetPos = Vector2.ZERO

# TODO: Move this entirely to ColorPlate class next time please
var selectedColor = Color.white

var middle = Vector2(73, 73)
var max_dist = 96

onready var parent = get_parent()
export(NodePath) var valueBarPath
var valueBar : ValueBar

func _ready():
	valueBar = get_node(valueBarPath)
	if valueBar:
		valueBar.connect("valueBarDragged", self, "value_bar_dragged")

func value_bar_dragged():
	parent.selectedColor = selectedColor

func get_drag_data(pos):
	if (!isDragging):
		isDragging = true
		return pos

func can_drop_data(pos, data):
	return typeof(data) == typeof(pos)

func isWithinRect(pos):
	return (rect_global_position.x < pos.x) and (rect_global_position.y < pos.y) and (rect_global_position.x + rect_size.x > pos.x) and (rect_global_position.y + rect_size.y > pos.y)

var tapped = false
func _input(event):
	if !is_visible_in_tree():
		return
	
	if event is InputEventScreenTouch and event.pressed:
		if isWithinRect(event.position):
			targetPos = event.position
			$Selection.rect_position = (targetPos - rect_global_position) - $Selection.rect_size/2
			tapped = true
	if event is InputEventScreenTouch and event.pressed == false:
		isDragging = false
	elif event is InputEventScreenDrag and isDragging:
		targetPos = event.position

func drop_data(pos, data):
	isDragging = false

func _process(_dt):
	if isDragging:
		var newPosition = (targetPos - rect_global_position) - $Selection.rect_size/2
		
		var distance_to_new = newPosition.distance_to(middle)
		if distance_to_new > max_dist:
			$Selection.rect_position = middle.direction_to(newPosition) * max_dist + middle
		else:
			$Selection.rect_position = newPosition
	
	var selection_angle = middle.direction_to($Selection.rect_position).angle()
	var selection_distance = middle.distance_to($Selection.rect_position)
	var result_color_noValue = Color.from_hsv((selection_angle + 5*PI/2)/(2*PI), selection_distance/max_dist, 1, 1)
	
	# TODO: use ONLY ColorPlate.selectedColor next time
	selectedColor = Color.from_hsv((selection_angle + 5*PI/2)/(2*PI), selection_distance/max_dist, valueBar.get_value_height_scale(), 1)
	
	if isDragging or tapped:
		parent.selectedColor = selectedColor
		tapped = false
	
	$Selection.modulate = selectedColor
	
	if parent:
		var valueBar = parent.get_node("ValueBar")
		if valueBar:
			valueBar.modulate = result_color_noValue
