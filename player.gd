extends KinematicBody

export(NodePath) onready var ray = get_node(ray) as RayCast
export var _mouse_sensitivity := .08
export var _speed: float = 7.5
export var _acc: float = 20.0
var direction: Vector3 = Vector3.ZERO
var velocity: Vector3 = Vector3()
var fall:Vector3 = Vector3()
export var jump := 4
var gravity := 9.8
const _sprintConst: float = 1.3
var jumpCount : int = 0
var start = self.transform.origin
var _collisionPoint : Vector3

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	GameEvents.connect("rayCollided",self,"getRayPoint")

func _input(event) -> void:
	aim(event)
	

func _physics_process(delta):
	#getInput()
	movement(delta)
	

func aim(event: InputEvent) -> void:
	var mouseMotion = event as InputEventMouseMotion
	if mouseMotion:
		rotation_degrees.y -= mouseMotion.relative.x * _mouse_sensitivity
		
		var currentTilt: float = $Camera.rotation_degrees.x
		currentTilt -= mouseMotion.relative.y * _mouse_sensitivity
		$Camera.rotation_degrees.x = clamp(currentTilt,-89.5,89.5)

func getRayPoint(collisionPoint):
	_collisionPoint = collisionPoint
	print(_collisionPoint)
	
	
func movement(delta) -> void:
	direction = Vector3(0,0,0)
	var sprintScale = 1,,,,,,,mmmmmmmmmmm,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
	var leftPressed    : bool = Input.is_action_pressed("move_left")
	var rightPressed   : bool = Input.is_action_pressed("move_right")
	var forwardPressed : bool = Input.is_action_pressed("move_forward")
	var backPressed    : bool = Input.is_action_pressed("move_back")
	var sprintPressed  : bool = Input.is_action_pressed("sprint")
	var sprintReleased : bool = Input.is_action_just_released("sprint")
	var jumpPressed    : bool = Input.is_action_just_pressed("jump")
	var dashPressed    : bool = Input.is_action_just_pressed("dash")
	var resPressed     : bool = Input.is_action_just_pressed("res")
	
	if not is_on_floor():
		fall.y -= gravity*delta
		_acc = 10 
		if jumpPressed and (jumpCount < 2):
			fall.y = jump
			jumpCount += 1
	else:
		jumpCount = 0
		_acc = 35
		if sprintPressed:sprintScale = _sprintConst
		if sprintReleased:sprintScale = 1
		
		if jumpPressed:
			fall.y = jump
			jumpCount += 1
	
		
	if forwardPressed : direction += -transform.basis.z 
	if backPressed : direction +=  transform.basis.z 

	if leftPressed : direction += -transform.basis.x 
	if rightPressed : direction +=  transform.basis.x 
	
	if resPressed : self.transform.origin = start
	
	
	direction = direction.normalized()

	velocity = velocity.linear_interpolate(direction * _speed * sprintScale, _acc * delta) 
	
	
	
	
	move_and_slide(velocity,Vector3.UP)
	move_and_slide(fall,Vector3.UP)
	
	if dashPressed:
		if (direction.z == 0) and (direction.x == 0):
			direction = -transform.basis.z
		direction.y = 0
		ray.set_enabled(true)
		direction *= 5
		
	else:
		ray.set_enabled(false) 
	
	
