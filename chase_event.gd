extends Node3D

@export var chaseObject: Node3D
@export var speed: float = 2.0
@export var chasing: bool = false

func setChaseObject(node: Node3D):
	$Taunt.play()
	chaseObject = node

func _physics_process(delta: float) -> void:
	if chaseObject == null or not chasing:
		return
	
	print(position)
	# Get direction toward the chaseObject
	var direction: Vector3 = (chaseObject.global_transform.origin - global_transform.origin).normalized()

	# Move toward the target at a constant speed
	global_translate(direction * speed * delta)


func _on_kill_area_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and chasing:
		body.quickTimeEvent() # Replace with function body.
