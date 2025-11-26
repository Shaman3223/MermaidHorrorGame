class_name NoiseEvent extends Node3D

@export var isSafe: safety = safety.RANDOM
@export var isProximityActivated: bool = true

enum safety{
	ALWAYS_SAFE,
	ALWAYS_DANGEROUS,
	RANDOM
}

@export var endOnCompletion: bool = false
@export var dangerRadius: float = 17.0
@export var activationRadius: float = 10.0
@export var activationTime: float = 10.0
@export var folderName: String = "splash"

@export var animalSounds: Array[AudioStream]
@export var sirenSounds:  Array[AudioStream]

func load_mp3_folder(foldername: String) -> Array[AudioStream]:
	var path: String = "res://Sounds/" + foldername
	var sounds: Array[AudioStream] = []
	var dir := DirAccess.open(path)

	if dir:
		dir.list_dir_begin()
		var file_name := dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".mp3"):
				var stream: AudioStream = load(path + "/" + file_name)
				if stream:
					sounds.append(stream)
			file_name = dir.get_next()
		dir.list_dir_end()
	return sounds


func _ready() -> void:
	print("hola como estats")
	animalSounds = load_mp3_folder(folderName)
	$Interval.wait_time = activationTime
	if not isProximityActivated:
		$Interval.start()
	$Area3D/CollisionShape3D.shape.radius = dangerRadius
	$ActivationRadius/CollisionShape3D.shape.radius = activationRadius

func _on_interval_timeout() -> void:
	emitEvent()

func emitEvent():
	print("I am screetching " + self.name)
	$AudioStreamPlayer3D.pitch_scale = randf_range(0.9,1.05)
	match isSafe:
		safety.ALWAYS_SAFE:
			playAnimalSound()
		safety.ALWAYS_DANGEROUS:
			playSirenSound()
		safety.RANDOM:
			var isSiren: bool = bool(randi_range(0,1))
			if isSiren:
				playSirenSound()
			elif !isSiren:
				playAnimalSound()
	if endOnCompletion:
		await $GPUParticles3D.finished
		queue_free()


func playSirenSound():
	$AudioStreamPlayer3D.stream = sirenSounds[randi_range(0,sirenSounds.size())-1]
	$GPUParticles3D.emitting = true
	$AudioStreamPlayer3D.play()
	var mainScene = get_parent().get_parent()
	if mainScene:
		mainScene.tempQuiet()
		mainScene.lastSirenEvent = self

func playAnimalSound():
	if animalSounds.size() < 1:
		print("animal sounds did not load")
		return
	$AudioStreamPlayer3D.stream = animalSounds[randi_range(0,animalSounds.size())-1]
	$GPUParticles3D.emitting = true
	$AudioStreamPlayer3D.play()

func isPlayerClose() -> bool:
	for bodies in $Area3D.get_overlapping_bodies():
		if bodies is CharacterBody3D:
			return true
	return false

func _on_activation_radius_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and isProximityActivated:
		emitEvent()
