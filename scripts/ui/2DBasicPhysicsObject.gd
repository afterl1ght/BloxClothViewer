extends Control

# physics object that supports only 1 forward direction (goDirection) + gravity
class_name BasicPhysicsObject2D

signal onBoundCollision(normal)
signal onBoundCollisionLeave(normal)

var isColliding = false

var gravity = Vector2(0, 0.98)
var velocity = Vector2(0,0)
var goDirection = Vector2(0,0)
var gyro = 0 # degrees/step
var autogyro = true # rotates as it moves
var cor = 0.4 # this isnt what you probably think it is - honestly dont know anymore
var xcor = 0.4 # the same for this
var xresist = 0.25
var rest_speed = Vector2(1, 1)

var pendingForce = false
var doResetVelocity = false

var xsign = 1

var boundStart = Vector2(0,0)
var boundEnd = Vector2(0,0)

func _ready():
	# by default use screen bounds for now
	boundEnd = get_viewport_rect().size

func applyForce(forceVector2 : Vector2, resetVelocity = false):
	if resetVelocity:
		doResetVelocity = true
	
	if pendingForce:
		goDirection += forceVector2
	else:
		goDirection = forceVector2
		pendingForce = true

var previousCollisionNormal = Vector2(0,0)
var previousLocation = rect_global_position
func _physics_process(dt):
	if !visible:
		isColliding = false
		return
		
	if doResetVelocity:
		xsign = 1
		velocity = Vector2(0,0)
		doResetVelocity = false
	
	rect_position += velocity
	velocity += gravity
	
	if autogyro:
		var x_real_velocity = rect_global_position.x - previousLocation.x
		gyro = x_real_velocity
	
	var collisionNormal = Vector2(0,0)
	
	# when applyForce() is called, this should be true
	if pendingForce:
		velocity.x += (goDirection.x * xsign)
		velocity.y += (goDirection.y)
		goDirection = Vector2(0,0)
		pendingForce = false # force applied, waiting for future forces
	
	if (((rect_position.x + rect_size.x * rect_scale.x) > boundEnd.x) or ((rect_position.x) < 0)):
		xsign *= -1
		velocity.x *= -1
		if ((rect_position.x) < 0):
			rect_position.x = 0
		else:
			rect_position.x = boundEnd.x - (rect_size.x * rect_scale.x)
		
		collisionNormal.x = sign(xsign)
		
	if ((rect_position.y + rect_size.y * rect_scale.y) >= boundEnd.y):
		if (abs(velocity.y) <= 4.2875):
			velocity.y = 0
		velocity.y = velocity.y * -(1-cor)
		rect_position.y = boundEnd.y - (rect_size.y * rect_scale.y)
		velocity.x *= (1-xcor) # If on ground, apply friction
		
		collisionNormal.y = -1 # There's no boundary for top lol
		
	var fireCollisionSignal = false
	if (collisionNormal != Vector2(0,0)):
		if !isColliding:
			fireCollisionSignal = true
		isColliding = true
		if fireCollisionSignal:
			emit_signal("onBoundCollision", collisionNormal)
	else:
		if isColliding:
			fireCollisionSignal = true
		isColliding = false
		if fireCollisionSignal:
			emit_signal("onBoundCollisionLeave", previousCollisionNormal)
			
	rect_rotation += gyro*(1-cor)
			
	previousCollisionNormal = collisionNormal
	previousLocation = rect_global_position
