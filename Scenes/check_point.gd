class_name CheckPoint extends Node3D

signal CheckPointUnlocked

var lastPosition: Vector3

@onready var main : Node3D = $".."


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and lastPosition != null:
		CheckPointUnlocked.emit() # Replace with function body.
		
		if body.lastCheckpoint == self:
			return
		
		$AnimationPlayer.play("light up")
		body.lastCheckpoint = self
		$AudioStreamPlayer3D.play()
		body.checkpointGained()
		lastPosition = body.global_position
		
		if self.name == "Checkpoint01":
			main.skyAnimate(0,1)
		elif self.name == "Checkpoint02":
			main.skyAnimate(1,2)
		elif self.name == "Checkpoint03":
			main.skyAnimate(2,3)
		elif self.name == "Checkpoint04":
			main.skyAnimate(3,4)
		elif self.name == "Checkpoint04":
			main.skyAnimate(3,4)
