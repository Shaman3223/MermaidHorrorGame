extends Node3D

@export var chaseObject: Node3D
@export var speed: float = 5.0
@export var chasing: bool = false
@export var expireTime: float = 20.0
@export var scream: bool = false

@onready var lorettaAnimator: AnimationPlayer = $LorettaNormalizer

func _ready() -> void:
	lorettaAnimator.play("swim")
	$Timer.wait_time = expireTime
	$Timer.start()

func setChaseObject(node: Node3D):
	$Taunt.play()
	chaseObject = node

func startChase():
	chasing = true
	if scream:
		$Scream.play()

func _physics_process(delta: float) -> void:
	
	if chaseObject == null or not chasing:
		return
	
	look_at(chaseObject.global_position)
	# Get direction toward the chaseObject
	var direction: Vector3 = (chaseObject.global_transform.origin - global_transform.origin).normalized()

	# Move toward the target at a constant speed
	global_translate(direction * speed * delta)


func _on_kill_area_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and chasing:
		body.quickTimeEvent() # Replace with function body.
		queue_free()

func _on_timer_timeout() -> void:
	if scream:
		await $Scream.finished
	
	lorettaAnimator.play("sink")
	await  lorettaAnimator.animation_finished
	queue_free() # Replace with function body.
