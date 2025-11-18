extends Node3D

var noiseEventScene : PackedScene = preload("res://noise_event.tscn")

func _ready() -> void:
	for area in get_children():
		if area is Area3D and area.name.contains("Noise"):
			area.body_entered.connect(isPlayerInArea.bind(area))


func isPlayerInArea(body: Node3D, area: Area3D):
	if body is CharacterBody3D:
		spawn_noise_event(area)
		print("area entered")


func spawn_noise_event(area: Area3D):
	var noise : NoiseEvent = noiseEventScene.instantiate()
	noise.isSafe = false
	add_child(noise)

	var shape: Shape3D = area.get_node("CollisionShape3D").shape
	var area_transform := area.global_transform

	var pos := area_transform.origin  # fallback

	# BOX SHAPE ---------------------------------------------------------
	if shape is BoxShape3D:
		var extents: Vector3 = shape.size * 0.5

		var local_random := Vector3(
			randf_range(-extents.x, extents.x),
			1.104 - area_transform.origin.y,   # convert to local Y offset
			randf_range(-extents.z, extents.z)
		)

		pos = area_transform * local_random

	# SPHERE SHAPE ------------------------------------------------------
	elif shape is SphereShape3D:
		var r :float = shape.radius

		var dir := Vector3(
			randf_range(-1.0, 1.0),
			0.0,
			randf_range(-1.0, 1.0)
		).normalized()

		var dist := randf_range(0.0, r)

		# Set Y manually while keeping it inside radius horizontally
		var local_random := Vector3(
			dir.x * dist,
			1.104 - area_transform.origin.y,
			dir.z * dist
		)

		pos = area_transform * local_random

	# ASSIGN POSITION ---------------------------------------------------
	noise.global_position = pos
