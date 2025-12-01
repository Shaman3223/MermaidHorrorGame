class_name mainGame extends Node3D
var BKGVolume: float = 0
@onready var bkgStreamPlayer: AudioStreamPlayer = $AudioStreamPlayer

var lastSirenEvent: Node3D

const mainMenu = preload("res://Scenes/main_menu.tscn")

@onready var player: CharacterBody3D = $CharacterBody3D


func _ready() -> void:
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
	bkgStreamPlayer.volume_db = move_toward(bkgStreamPlayer.volume_db, BKGVolume, 1.0)

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


func playerEntered(body: Node3D) -> void:
	pass # Replace with function body.


func _on_character_body_3d_we_have_finished_the_game() -> void:
	get_tree().change_scene_to_packed(mainMenu)
	print("switched to main menu")

func skyAnimate(start: float, end: float):
	$envAnimator.play_section("sky_anim", start, end)
