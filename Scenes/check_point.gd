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
		
		match self.name:
			"CheckPoint01":
				main.skyAnimate(0,0.5)
				print("hello")
			"CheckPoint02":
				main.skyAnimate(0.5,1)
				print("hello2")
			"CheckPoint03":
				main.skyAnimate(1,2)
				print("hello3")
			"CheckPoint04":
				main.skyAnimate(1,2)
			"CheckPoint05":
				main.skyAnimate(2,3)
