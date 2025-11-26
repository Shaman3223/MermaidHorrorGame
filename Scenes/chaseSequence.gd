extends Area3D

var inChase: bool = false
# make it so when you enter this node a 
# brief timer goes off and then a chase will begin. 
# once the Siren gets you it goes into a quick time event. s
# Called when the node enters the scene tree for the first time.

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		print("have player")
		inChase = true
		
