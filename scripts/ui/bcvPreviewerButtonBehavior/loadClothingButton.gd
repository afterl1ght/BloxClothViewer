extends BCVPreviewerButton

class_name ClothingLoadButton

export(bool) var isShirt = false
export(NodePath) var opposingClothingButtonPath # If shirt, this is pants. If pants, this is shirt.

export(NodePath) var importNotifierPath
onready var importNotifier : ImportNotifier = get_node(importNotifierPath)

var available = false
var requested = false
signal on_opposing_clothing_request

var currentDefaultBodyMat = "blockmat6"

onready var blockmatpants = Preloader.blockmatpants
onready var blockmatpantsHybrid = Preloader.blockmatpantsHybrid
onready var blockmatshirt = Preloader.blockmatshirt

# Gallery image loading for Android targets.
var androidImgLoader

func _ready():
	randomize()
	if uiMain and uiMain.skinModelPath:
		available = true
	
	if Engine.has_singleton("GodotGetImage"):
		androidImgLoader = Engine.get_singleton("GodotGetImage")
		androidImgLoader.setOptions({"image_format" : "png"})
	else:
		available = false
	
	var opposingClothingButton = get_node(opposingClothingButtonPath)
	
	if androidImgLoader and opposingClothingButton:
		opposingClothingButton.connect("on_opposing_clothing_request", self, "_on_opposing_clothing_request")
		androidImgLoader.connect("image_request_completed", self, "_on_image_request_completed")
		androidImgLoader.connect("error", self, "_on_error")
		androidImgLoader.connect("permission_not_granted_by_user", self, "_on_permission_not_granted_by_user")
	else:
		print("Failure")
		androidImgLoader = null
		available = false

func _pressed():
	if androidImgLoader:
		emit_signal("on_opposing_clothing_request")
		requested = true
		androidImgLoader.getGalleryImage()
	else:
		print("Unable to handle action request.")
		importNotifier.submitNotice("fail")
		requested = false
		
func _on_opposing_clothing_request():
	# Seem like you're pants and shirts gets picked. This was to make sure they willn't ran in at same time.
	requested = false

func _on_image_request_completed(dict):
	#if available:
	if not requested:
		return
		
	# Returns Dictionary of PoolByteArray
	var count = 0
	for img_buffer in dict.values():
		count += 1
		var image = Image.new()
		
		# Use load format depending what you have set in plugin setOption()
		#var error = image.load_jpg_from_buffer(img_buffer)
		var error = image.load_png_from_buffer(img_buffer)
		
		if error != OK:
			print("Load buffer failed. Returned info: ", error)
			importNotifier.submitNotice("fail")
		else:
			print("Loading texture... ", count)
			yield(get_tree(), "idle_frame")
			var texture = ImageTexture.new()
			texture.create_from_image(image, 16)
			
			randomize()
			if randf() > 0.975:
				if isShirt:
					blockmatshirt.albedo_texture = texture
				else:
					blockmatpants.albedo_texture = texture
					blockmatpantsHybrid.albedo_texture = texture
				
				importNotifier.submitNotice("witch")
			else:
				if isShirt:
					blockmatshirt.albedo_texture = texture
					importNotifier.submitNotice("shirt_success")
				else:
					randomize()
					blockmatpants.albedo_texture = texture
					blockmatpantsHybrid.albedo_texture = texture
					
					if randf() > 0.95:
						importNotifier.submitNotice("pantsies_success")
					else:
						importNotifier.submitNotice("pants_success")
					
			# after that, run some checks to see if the texture is eligible for uploading.
			if texture.get_size() != Vector2(585, 559):
				# Roblox requires the texture to be the exact same size of 585, 559.
				$Status.mouse_filter = Control.MOUSE_FILTER_STOP
				$Status.texture_normal = Preloader.statuswarning
				$Status/bubble/Tween.stop_all()
				$Status/bubble.modulate = Color.transparent
				$Status/bubble.visible = true
			else:
				$Status.mouse_filter = Control.MOUSE_FILTER_PASS
				$Status.texture_normal = Preloader.statusok
				$Status/bubble/Tween.stop_all()
				$Status/bubble.modulate = Color.transparent
				$Status/bubble.visible = false
	
	requested = false

func _on_permission_not_granted_by_user(permission):
	requested = false
	importNotifier.submitNotice("fail_storage")
	androidImgLoader.resendPermission()

func _on_error(_err):
	importNotifier.submitNotice("fail")
	requested = false
	pass

	#var image = Image.new()
	#var err = image.load("path/to/the/image.png")
	#if err != OK:
	#	pass
	#var texture = ImageTexture.new()
	#texture.create_from_image(image, 0)
