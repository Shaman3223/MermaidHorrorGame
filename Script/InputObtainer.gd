extends Control

var firstTime: bool = true

var start_pos:Vector2
@export var min_swipe_distance := 100
var lastSwipePosition: Vector2
var madeMinimum: bool = true

signal mouseEventObserved(charge: int, dir: Vector2,magnitude: int)
signal shake
var lastDirection: String = "Down"
var lastCharge: int = 1

var mapOn: bool = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		if madeMinimum:
			lastSwipePosition = event.position
			madeMinimum = false
		if (abs(lastSwipePosition.length() - event.position.length()) ) > min_swipe_distance and !madeMinimum:
			madeMinimum = true
			shake.emit()
	
	
	
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.is_pressed():
			start_pos = event.position
		else:
			var delta: Vector2 = event.position - start_pos
			detectDragForBoat(delta)

func detectDragForBoat(delta: Vector2):
	var mousePos: Vector2 = get_global_mouse_position()
	
	var isOnRight: bool = mousePos.x > get_viewport().size.x/3 * 2
	var isOnLeft: bool = mousePos.x < get_viewport().size.x/3
	
	if delta.length() < min_swipe_distance:
		return
	
	if not (isOnRight or isOnLeft):
		return
	
	if isOnLeft: lastCharge = -1
	if isOnRight: lastCharge = 1
	
	
	if abs(delta.x) < abs(delta.y):
		if delta.y < 0:
			lastDirection = "Up"
			#print("Swipe Up")
		else:
			lastDirection = "Down"
			#print("Swipe Down")
	else:
		if delta.x < 0:
			lastDirection = "Left"
			#print("Swipe Left")
		else:
			lastDirection = "Right"
			#print("Swipe Right")
	
	var direction: Vector2 = delta
	#print(direction)
	
	mouseEventObserved.emit(lastCharge,delta,delta.length())

func flashText(text: String):
	$AnimationPlayer.stop()
	$Label.text = text
	$AnimationPlayer.play("gained")

func toggleMap():
	$Letter.hide()
	$Label2/AnimationPlayer.stop()
	$Label2.hide()
	if mapOn:
		closeMap()
		mapOn = false
	else:
		openMap()
		mapOn = true
	

func openMap():
	$Compass.show()
	%SubViewportContainer.show()
	%AnimationPlayer.play("goUp")
	%AnimatedSprite2D.play("default")

func closeMap():
	if firstTime:
		flashText("Drag and release mouse in bottom corners to move")
	firstTime = false
	$Compass.hide()
	%AnimatedSprite2D.play("reverse")
	%AnimationPlayer.play("goDown")
	await %AnimatedSprite2D.animation_finished
	%SubViewportContainer.hide()

func compass():
	var player: Node = get_parent().get_parent().get_node("CharacterBody3D")
	
	if !player:
		return
	
	$Compass.rotation = wrap(player.rotation.y, 0.0, TAU)
