extends MeshInstance

# returns true if luma is over half
func lumacheck(col : Color):
	var kr = 0.299
	var kg = 0.587 
	var kb = 0.114
	var y = sqrt(kr*col.r*col.r + kg*col.g*col.g + kb*col.b*col.b)
	return (y > 0.5)

func _process(_dt):
	if lumacheck(Preloader.procsky.sky_top_color):
		# it's bright here, turn the grid darker
		Preloader.gridmat.albedo_color = Color(0.1,0.1,0.1,0.5)
	else:
		Preloader.gridmat.albedo_color = Color(1,1,1,0.1)
