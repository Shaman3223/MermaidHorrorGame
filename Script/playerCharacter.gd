extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var rotationalSpeed:float = 0.0

var pushVelocity: float = 0.0

var boatLag: float = 0.0
var boatLagBack: float = 0.0
var boatLerpRate: float = 100.0
var boatRockback: bool = false

var headLag: float = 0.0


func _physics_process(delta: float) -> void:
	velocity.z += 0.2 * delta
	
	rotation.y += rotationalSpeed
	$boat_prot.rotation.y = boatLag
	
	var sinvers: float = sin(rotation.y - PI/2) * pushVelocity
	var cosvers: float = cos(rotation.y - PI/2) * pushVelocity
	velocity.x += move_toward(sinvers, sinvers, 1)
	velocity.z += move_toward(cosvers, cosvers, 1)
	
	#var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
	
	pushVelocity = move_toward(pushVelocity, 0.0, 0.1 )
	
	velocity.x = move_toward(velocity.x, 0.0, 0.1)
	velocity.z = move_toward(velocity.z, 0.0, 0.1)
	
	rotationalSpeed = move_toward(rotationalSpeed, 0, 0.05)
	boatLag = move_toward(boatLag, boatLagBack, boatLerpRate)
	if boatLag < boatLagBack * 0.2 and boatRockback:
		boatLerpRate = 0.004
		boatRockback = false
	
	headLag = move_toward(headLag, 0, boatLerpRate)
	
	#display/window/size/viewport_width
	var screenWidth = get_viewport().size.x
	$Head/Path3D/PathFollow3D.progress_ratio = -$"../CanvasLayer/Control".get_global_mouse_position().x/screenWidth
	move_and_slide()


func forwardPaddle(charge, dir, mag):
	var rotateDividend: float = 40
	var pushPower: float = 1.5
	#if dir == "Up":
		#pushPower = -0.6
	#if dir == "Right" or "Left":
		#rotateDividend = 30
		#pushPower = 0.2

	rotationalSpeed += charge * (PI/rotateDividend) * mag/(rotateDividend * 25)
	
	pushVelocity += pushPower
	
	headLag += charge * (PI/40) * mag/300
	
	boatLag += -charge * (PI/rotateDividend ) * mag/(rotateDividend * 30)
	boatLagBack = (boatLag * -1) * 0.2
	boatLerpRate = 0.002
	boatRockback = true
