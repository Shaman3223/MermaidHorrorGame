extends CharacterBody3D

#constants
const SPEED = 5.0

#rotation/turning
var rotationalSpeed: float = 0.0
var target_rotation_speed: float = 0.0
var queued_rotation_speed: float = 0.0

#delay rotation
var boatLag: float = 0.0
var headLag: float = 0.0

#forward movement
var forward_dir := Vector3.ZERO
var pushVelocity: float = 0.0

#tilt
var tilt_x: float = 0.0
var target_tilt_x: float = 0.0

#wobble
var wobble_timer: float = 0.0
var wobble_duration: float = 0.5
var wobble_amplitude: float = 0.0

#checkpoint
var lastCheckpoint: Node3D

func _physics_process(delta: float) -> void:
	velocity.z += 0.2 * delta

	forward_dir = Vector3(
		sin(rotation.y - PI/2),
		0,
		cos(rotation.y - PI/2)
	)
#apply forward velocity in the direction the boat is facing
	velocity += forward_dir * pushVelocity
#delay turning
	if pushVelocity < 0.1 and queued_rotation_speed != 0.0:
		target_rotation_speed = queued_rotation_speed
		queued_rotation_speed = 0.0
#lerp rotation
	rotationalSpeed = move_toward(rotationalSpeed, target_rotation_speed, 0.01)
	rotation.y += rotationalSpeed
	$boat_prot.rotation.y = boatLag

#graudally reduce velocity
	pushVelocity = move_toward(pushVelocity, 0.0, 0.08)
	velocity.x = move_toward(velocity.x, 0.0, 0.01)
	velocity.z = move_toward(velocity.z, 0.0, 0.01)

#dampen lag
	boatLag = move_toward(boatLag, 0.0, 0.02)
	headLag = move_toward(headLag, 0, 0.02)

#add wobble effect
	var wobble_x: float = 0.0
	if wobble_timer > 0.0:
		wobble_timer -= delta
		#aadjust wobble intensity
		wobble_x = wobble_amplitude * sin((1.0 - wobble_timer / wobble_duration) * PI * 3) * (wobble_timer / wobble_duration)

#add tilt effect
#adjust both tilt & wobble
	tilt_x = move_toward(tilt_x, target_tilt_x + wobble_x, 0.01)
	$boat_prot.rotation.x = tilt_x

	movePaddleWMouse()

	move_and_slide()

#paddling
func forwardPaddle(charge: int, dir: Vector2, mag: float):
	#charge = length of paddle, dir = right left down


#adjust tilt intensity 
	var rotateDividend: float = 45.0 - abs(dir.x/600)
	var pushPower: float = 0.9 * (dir.y/1000)
	
	if abs(dir.y) > abs(dir.x):
		tilt_x = 0.05 * charge
	else:
		tilt_x = 0.0

	queued_rotation_speed = charge * (PI/rotateDividend) * mag/(rotateDividend * 300)
	if pushVelocity < 30.0:
		pushVelocity += pushPower
	headLag += charge * (PI/40) * mag/300
	boatLag = 0.0

	await get_tree().create_timer(0.15).timeout
	#tilt & wobble after stroke
	target_tilt_x = 0.0
	wobble_amplitude = 0.02
	wobble_timer = wobble_duration

#reset to last checkpoint 
func die():
	if lastCheckpoint != null:
		global_position = lastCheckpoint.lastPosition
	print("I have died")

func _on_kill_area_body_entered(body: Node3D) -> void:
	#Just For Testing
	if body == self:
		die()

func movePaddleWMouse():
	var control: Control = getControl()
	if !control:
		return

	var screen_width: float = get_viewport().size.x
	var paddle_parent: PathFollow3D = $Head/Path3D/PathFollow3D

	# Convert mouse X position to a normalized 0–1 ratio
	var mouse_ratio: float = 1.0 - clamp(control.get_local_mouse_position().x / screen_width, 0.0, 1.0)

	# Optional: invert or offset if movement is reversed
	paddle_parent.progress_ratio = clamp(mouse_ratio, 0.05, 0.95)

	print(paddle_parent.progress_ratio)


func getControl() -> Control:
	var control: Control = get_parent().get_node("CanvasLayer").get_node("Control")
	if control:
		return control
	else :
		return null

func checkpointGained():
	getControl().flashText("Checkpoint Found")
