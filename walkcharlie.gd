extends CharacterBody2D

const TILE_SIZE = 64
const MOVE_SPEED = 300.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var moving := false
var target_pos := Vector2.ZERO

func _ready() -> void:
	target_pos = global_position
	z_index = 1

func _physics_process(delta: float) -> void:
	var craft_ui = get_node("/root/Mapa/CanvasLayerCraft/CraftUI")
	if craft_ui.aberto or Dialogo.aberto:
		velocity = Vector2.ZERO
		moving = false
		anim.stop()
		return

	if moving:
		_mover_para_destino(delta)
	else:
		_verificar_input()

func _verificar_input() -> void:
	var direcao := Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		direcao = Vector2.UP
		anim.play("BackWalk")
	elif Input.is_action_pressed("ui_down"):
		direcao = Vector2.DOWN
		anim.play("FrontWalk")
	elif Input.is_action_pressed("ui_left"):
		direcao = Vector2.LEFT
		anim.play("LeftWalk")
	elif Input.is_action_pressed("ui_right"):
		direcao = Vector2.RIGHT
		anim.play("RightWalk")
	else:
		anim.stop()
		return

	# Verifica se tem uma caixa na direção e empurra
	var pos_frente = global_position + direcao * TILE_SIZE
	for caixa in get_tree().get_nodes_in_group("caixa"):
		if caixa.global_position.distance_to(pos_frente) < 8.0:
			caixa.mover(direcao)

	var colisao = move_and_collide(direcao * TILE_SIZE, true)
	if colisao:
		var distancia_livre = colisao.get_travel()
		if distancia_livre.length() < 0.5:
			anim.stop()
			return
		target_pos = global_position + distancia_livre
	else:
		target_pos = global_position + direcao * TILE_SIZE
	moving = true

func _mover_para_destino(delta: float) -> void:
	var distancia := target_pos - global_position
	var passo := MOVE_SPEED * delta

	if distancia.length() <= passo:
		global_position = target_pos
		velocity = Vector2.ZERO
		moving = false
	else:
		velocity = distancia.normalized() * MOVE_SPEED
		move_and_slide()
