extends Control

class_name ValueBar

signal valueBarDragged

var isDragging = false
var targetPos = Vector2.ZERO

onready var parent = get_parent() # parent is ColorPlate/ColorPlateCompat

func get_height_correction():
	# clamped offset min/max backwards rect.y/4 from rect.y/2
	return $Selection.rect_size.y/2 + $Selection.rect_size.y/4

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
	if event is InputEventScreenTouch and event.pressed:
		if isWithinRect(event.position):
			targetPos = event.position
			# remember to adjust get_height_correction() after change
			$Selection.rect_position = Vector2($Selection.rect_position.x, clamp(targetPos.y - rect_global_position.y, -$Selection.rect_size.y/4, rect_size.y - 3*$Selection.rect_size.y/4))
			tapped = true
			#selection position height for value bar
	if event is InputEventScreenTouch and event.pressed == false:
		isDragging = false
	elif event is InputEventScreenDrag and isDragging:
		targetPos = event.position

func drop_data(pos, data):
	isDragging = false
	
func get_value_height_scale():
	var selection_height = $Selection.rect_position.y
	return lerp(1, 0, selection_height / (rect_size.y - get_height_correction()))
	
func set_value_height_scale(zero_to_one):
	$Selection.rect_position = Vector2($Selection.rect_position.x, (rect_size.y - get_height_correction()) * lerp(1, 0, zero_to_one))
	
func _process(_dt):
	if isDragging:
		# get drag height here
		# after adjusting clamp offset to make slider more accurate remember to adjust get_height_correction()
		# just wanna make this fast so i can focus on my main project
		var selection_height = clamp(targetPos.y - rect_global_position.y, -$Selection.rect_size.y/4, rect_size.y - 3*$Selection.rect_size.y/4)
		$Selection.rect_position = Vector2($Selection.rect_position.x, selection_height)
	
	if isDragging or tapped:
		emit_signal("valueBarDragged")
		tapped = false
	
	var targetColor = Color.white * get_value_height_scale()
	$Selection.modulate = Color(targetColor.r, targetColor.g, targetColor.b, $Selection.modulate.a)
