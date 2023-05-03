extends RigidBody2D

export var coin: PackedScene = preload("res://scenes/characters_overlay/coin/coin.tscn")
export var coin_nb: float = 10.0

var exploded: bool = false

onready var rot_point: Node2D = $RotPoint
onready var position_2d: Position2D = $RotPoint/Position2D

func _ready() -> void:
	randomize()
	coin_nb = randi()%15+1

func explode() -> void:
	if exploded: return
	exploded = true
	var instances: Array = []
	for i in range(coin_nb):
		var inst = coin.instance()
		get_parent().call_deferred("add_child", inst)
		instances.append(inst)
		
	for inst in instances:
		# Make sur its pointing towards the sky
		rot_point.rotation -= rotation
		rot_point.look_at(Vector2.UP)
		# Get a random rotation from here
		rot_point.rotation_degrees = rand_range(-150.0, -20.0)
		
		inst.global_position = position_2d.global_position
		inst.apply_central_impulse(position_2d.global_transform.x * 300.0)

	queue_free()

func push(impulse: Vector2) -> void:
	apply_central_impulse(impulse)
	explode()

func _on_BoxCoin_body_entered(body: Node) -> void:
	if not body.is_in_group("Characters"): return
	explode()
