extends Node3D

var showcredits: bool = false

func _ready() -> void:
	for button: Button in $CanvasLayer/Control/VBoxContainer.get_children():
		button.mouse_entered.connect(playUINoise)
		button.pressed.connect(playStartNoise)

var maingame = load("res://Scenes/main.tscn")

func playUINoise():
	$ui.play()

func playStartNoise():
	$start.play()

func fadeIn():
	$CanvasLayer/Control/AnimationPlayer.play("fadeIn")

func goToGame():
	# Replace the current scene with the loaded main game
	get_tree().change_scene_to_packed(load("res://Scenes/main.tscn"))
	print("switched to main game")

func _on_start_pressed() -> void:
	fadeIn()
	await $start.finished
	goToGame()

func quit_game():
	get_tree().quit()

func toggleCredits():
	showcredits = !showcredits
	$CanvasLayer/Control/Panel.visible = showcredits
