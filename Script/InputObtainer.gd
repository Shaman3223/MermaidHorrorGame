extends Control

var start_pos:Vector2
@export var min_swipe_distance := 100
signal rightSide(dir: String, magnitude: int)
signal leftSide(dir: String,magnitude: int)

signal mouseEventObserved(charge: int, dir: String,magnitude: int)
var lastDirection: String = "Down"
var lastCharge: int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




func _input(event: InputEvent):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.is_pressed():
			start_pos = event.position
		else:
			var delta: Vector2 = event.position - start_pos
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
			
			mouseEventObserved.emit(lastCharge,lastDirection,delta.length())
