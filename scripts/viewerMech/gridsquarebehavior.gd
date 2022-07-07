extends MeshInstance

# returns true if luma is over half
func lumacheck(col : Color):
	var kr = 0.299
	var kg = 0.587 
	var kb = 0.114
	var y = sqrt(kr*col.r*col.r + kg*col.g*col.g + kb*col.b*col.b)
	return y#(y > 0.51)

func _process(_dt):
	Preloader.gridmat.albedo_color = lerp(Color(1,1,1,0.1),Color(0.1,0.1,0.1,0.5),min(lerp(0, 2, lumacheck(Preloader.fakeskymat.get_shader_param("albedo"))), 1))
