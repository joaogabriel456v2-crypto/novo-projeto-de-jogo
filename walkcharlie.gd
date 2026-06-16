extends CharacterBody2D

const TILE_SIZE = 64          # tamanho do tile em pixels
const MOVE_SPEED = 300.0      # velocidade de deslizamento entre os tiles

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var moving := false           # true enquanto estiver se movendo pro próximo tile
var target_pos := Vector2.ZERO  # posição destino do movimento atual

func _ready() -> void:
	target_pos = global_position  # começa parado onde está

func _physics_process(delta: float) -> void:
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

	# Define o tile destino e começa o movimento
	target_pos = global_position + direcao * TILE_SIZE
	moving = true

func _mover_para_destino(delta: float) -> void:
	var distancia := target_pos - global_position
	var passo := MOVE_SPEED * delta

	if distancia.length() <= passo:
		# Chegou no tile destino — trava exatamente na posição
		global_position = target_pos
		velocity = Vector2.ZERO
		moving = false
	else:
		# Ainda está a caminho — continua se movendo
		velocity = distancia.normalized() * MOVE_SPEED
		move_and_slide()
