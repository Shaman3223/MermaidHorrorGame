extends Control

var start_pos:Vector2
@export var min_swipe_distance := 100
var lastSwipePosition: Vector2
var madeMinimum: bool = true

signal mouseEventObserved(charge: int, dir: Vector2,magnitude: int)
signal shake
var lastDirection: String = "Down"
var lastCharge: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		if madeMinimum:
			lastSwipePosition = event.position
			madeMinimum = false
		if (abs(lastSwipePosition.length() - event.position.length()) ) > min_swipe_distance and !madeMinimum:
			madeMinimum = true
			print("shake")
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
			print("Swipe Up")
		else:
			lastDirection = "Down"
			print("Swipe Down")
	else:
		if delta.x < 0:
			lastDirection = "Left"
			print("Swipe Left")
		else:
			lastDirection = "Right"
			print("Swipe Right")
	
	var direction: Vector2 = delta
	print(direction)
	
	mouseEventObserved.emit(lastCharge,delta,delta.length())

func flashText(text: String):
	$Label.text = text
	$AnimationPlayer.play("gained")
