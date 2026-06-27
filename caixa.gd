extends CharacterBody2D

const TILE_SIZE = 64
const MOVE_SPEED = 300.0

var moving := false
var target_pos := Vector2.ZERO

func _ready() -> void:
	target_pos = global_position
	add_to_group("caixa")

func mover(direcao: Vector2) -> bool:
	if moving:
		return false

	var colisao = move_and_collide(direcao * TILE_SIZE, true)
	if colisao:
		return false

	target_pos = global_position + direcao * TILE_SIZE
	moving = true
	return true

func _physics_process(delta: float) -> void:
	if not moving:
		return

	var distancia := target_pos - global_position
	var passo := MOVE_SPEED * delta

	if distancia.length() <= passo:
		global_position = target_pos
		velocity = Vector2.ZERO
		moving = false
		_verificar_botao()
	else:
		velocity = distancia.normalized() * MOVE_SPEED
		move_and_slide()

func _verificar_botao() -> void:
	for botao in get_tree().get_nodes_in_group("botao_pressao"):
		if botao.global_position.distance_to(global_position) < 8.0:
			botao.ativar()
