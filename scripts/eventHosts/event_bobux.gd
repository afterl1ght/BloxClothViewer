extends EventOrganizer

export(NodePath) var pichitboxPath
onready var pichitbox : PicHitbox = get_node(pichitboxPath)

var bouncesTillExplode = 1
var bounces = 0

func _ready():
	event_name = "bobux"
	event_max_duration = 100
	count_runtime_with_physics = true
	
	$conicalFlask.connect("onBoundCollision", self, "on_flask_collide")
	$conicalFlask.connect("onBoundCollisionLeave", self, "on_flask_collide_leave")
	$boom.connect("animation_finished", self, "boom_finished")

func _run_event():
	._run_event()
	randomize()
	bouncesTillExplode = randi() % 3 + 1
	bounces = 0
	
	$conicalFlask.rect_position = Vector2(0,0)
	if pichitbox:
		$conicalFlask.rect_position = pichitbox.rect_global_position
	
	var throwForce = Vector2(rand_range(5, 10), rand_range(-20, -10))
	$conicalFlask.applyForce(throwForce, true)
	$conicalFlask.visible = true
	event_runtime = event_max_duration
	
func _physics_event():
	pass
	
func _stop_event():
	$conicalFlask.rect_position = Vector2(0,0)
	$conicalFlask.visible = false
	bounces = 0
	._stop_event()

func easeinexp(a : float, b: float = 2): # a - alpha (0 - 1), b - base (higher = steeper)
	if a == 0:
		return 0
	else:
		return pow(b, 10 * a - 10);

# conicalFlask collision events
func on_flask_collide(normal):
	#print("Collision detected! - ", normal)
	bounces += 1
	if (bounces >= bouncesTillExplode):
		# do explosion
		bouncesTillExplode = INF
		$conicalFlask.visible = false
		
		$boom.frame = 0
		$boom.position = $conicalFlask.rect_position + $conicalFlask.rect_size/2
		$boom.visible = true
		$boom.play("boom")
		
		# Spawn a bunch of bobux
		randomize()
		var maxQuantity = 20
		var quantityMul = max(1/maxQuantity, easeinexp(rand_range(0, 1)))
		
		for i in range(randi() % int(ceil(maxQuantity * quantityMul)) + 1):
			var bobuxclone = $bobuxcoin.duplicate()
			
			if bobuxclone.get_parent():
				bobuxclone.get_parent().remove_child(bobuxclone)	
			$bobuxContainer.add_child(bobuxclone)
			
			bobuxclone.xcor = 0.01
			
			bobuxclone.rect_position = $boom.position
			bobuxclone.rect_position.y = min(bobuxclone.rect_position.y, bobuxclone.boundEnd.y - (bobuxclone.rect_size.y * bobuxclone.rect_scale.y + 1))
			
			var throwForce = Vector2(rand_range(-20, 20), rand_range(-40, -30))
			bobuxclone.applyForce(throwForce, true)
			bobuxclone.visible = true
			bobuxclone.isPersistent = false
		
		_stop_event()
	
func on_flask_collide_leave(normal):
	#print("Collision left! - ", normal)
	pass

func boom_finished():
	$boom.visible = false
	$boom.position = Vector2(-1000, -1000)
