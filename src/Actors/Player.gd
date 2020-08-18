extends Actor

var doubleJumpFlag: bool = true

# delta is provided by engine to denote time since last frame
# _physics_process is called by engine 60 times per second
func _physics_process(delta: float) -> void:
	var direction: Vector2 = get_direction()
	velocity = calculate_move_velocity(velocity, direction, speed)
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	
func get_vertical_direction() -> float:
	var verticalDirection: float = 1.0
	
	if Input.is_action_just_pressed("jump") and (is_on_floor() or doubleJumpFlag == false):
		verticalDirection = -1.0
		doubleJumpFlag = !doubleJumpFlag
	
	return verticalDirection

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		get_vertical_direction()
	)

func calculate_move_velocity(
		linear_velocity: Vector2, 
		direction: Vector2, 
		speed: Vector2
	) -> Vector2:
	var new_velocity: Vector2= linear_velocity
	new_velocity.x = speed.x * direction.x
	new_velocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		new_velocity.y = speed.y * direction.y
	return new_velocity
