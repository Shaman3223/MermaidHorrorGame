extends Control

var start_pos:Vector2
@export var min_swipe_distance := 100
signal rightSide(dir: String, magnitude: int)
signal leftSide(dir: String,magnitude: int)

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
			
			var right_rect = $Right.get_global_rect()
			var left_rect = $Left.get_global_rect()
			
			var isOnRight: bool = right_rect.has_point(mousePos)
			var isOnLeft: bool = left_rect.has_point(mousePos)
			
			if delta.length() < min_swipe_distance:
				return
			
			if not (isOnRight or isOnLeft):
				return
			
			
			if abs(delta.x) < abs(delta.y):
				if delta.y < 0:
					if isOnLeft: leftSide.emit(delta.length())
					if isOnRight: rightSide.emit(delta.length())
					print("Swipe Up")
				else:
					print("Swipe Down")
			else:
				if delta.x < 0:
					print("Swipe Left")
				else:
					print("Swipe Right")
