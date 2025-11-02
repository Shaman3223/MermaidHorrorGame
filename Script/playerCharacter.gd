extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var rotationalSpeed:float = 0.0

var pushVelocity: float = 0.0

var boatLag: float = 0.0
var boatLagBack: float = 0.0
var boatLerpRate: float = 0.5
var rockback: bool = false


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
	if boatLag < boatLagBack * 0.2 and rockback:
		boatLerpRate = 0.0009
		rockback = false
		print("yippe kaiye")
	#display/window/size/viewport_width
	var screenWidth = get_viewport().size.x
	$Head/Path3D/PathFollow3D.progress_ratio = -$"../CanvasLayer/Control".get_global_mouse_position().x/screenWidth
	move_and_slide()

func paddleRight(mag: int):
	forwardPaddle(1, mag)

func paddleLeft(mag: int):
	forwardPaddle(-1, mag)

func forwardPaddle(charge, mag):
	rotationalSpeed += charge * (PI/16) * mag/500
	
	pushVelocity += 0.9
	
	boatLag += -charge * (PI/20) * mag/500
	boatLagBack = (boatLag * -1) * 0.2
	boatLerpRate = 0.002
	rockback = true
	print("paddle")
