extends Actor

var doubleJumpFlag: bool = true
export var stomp_impulse: float = 1000.0

func _on_EnemyDetector_area_entered(area: Area2D) -> void:
	_velocity = calculate_stomp_velocity(_velocity, stomp_impulse)

func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	queue_free()

# delta is provided by engine to denote time since last frame
# _physics_process is called by engine 60 times per second
func _physics_process(delta: float) -> void:
	var is_jump_interrupted: bool = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction: Vector2 = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	
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
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var out: Vector2= linear_velocity
	out.x = speed.x * direction.x
	out.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		out.y = speed.y * direction.y
	if is_jump_interrupted:
		out.y = 0.0
	return out

func calculate_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2:
	var out: Vector2 = linear_velocity
	out.y = -impulse
	return out


