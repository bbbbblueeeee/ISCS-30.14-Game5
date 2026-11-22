extends Node3D

var health: int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	# print("Enemy body entered")
	if body.is_in_group("bullet"):
		health -= 1
	if health <= 0:
		queue_free()

func hit():
	# print("Hit function detected")
	health -= 1
	if health <= 0:
		queue_free()
