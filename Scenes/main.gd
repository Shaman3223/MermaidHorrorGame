extends Node3D
var BKGVolume: float = 0
var MaxBKGVolume: float = 80.0
@onready var bkgStreamPlayer: AudioStreamPlayer = $AudioStreamPlayer

var lastSirenEvent: Node3D

@onready var player: CharacterBody3D = $CharacterBody3D


func _ready() -> void:
	$AudioStreamPlayer/Randomizer.start()
	$Sprite3D.hide()

func setBKGVolume(value: float):
	BKGVolume = value

func tempQuiet():
	setBKGVolume(-80.0)
	$AudioStreamPlayer/Timer.start()
	$QTETimer.start()
	await $AudioStreamPlayer/Timer.timeout
	setBKGVolume(0.0)

func _physics_process(delta: float) -> void:
	bkgStreamPlayer.volume_db = move_toward(bkgStreamPlayer.volume_db, BKGVolume, 0.1)

func _on_randomizer_timeout() -> void:
	if $AudioStreamPlayer/Timer.is_stopped():
		setBKGVolume(randf_range(-20.0, 0.0))



func QTE_timeout() -> void:
	if lastSirenEvent.isPlayerClose():
		player.quickTimeEvent()
		$DeathTimer.start()
	else:
		print("safe")

func _on_death_timer_timeout() -> void:
	if player.isInQTE:
		player.die() 
		player.exitQTE()
