extends Node3D

signal CheckPointUnlocked

var lastPosition: Vector3


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and lastPosition != null:
		CheckPointUnlocked.emit() # Replace with function body.
		
		$AnimationPlayer.play("light up")
		body.lastCheckpoint = self
		lastPosition = body.global_position
		
