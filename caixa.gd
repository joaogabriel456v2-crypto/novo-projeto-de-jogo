extends CharacterBody2D

@export var velocidade_maxima := 180.0
@export var desaceleracao := 700.0

func _ready() -> void:
	z_index = 1
	add_to_group("caixa")
	collision_layer = 0
	collision_mask = 0
	set_collision_layer_value(2, true)
	set_collision_mask_value(1, true)
	set_collision_mask_value(2, true)

func receber_empurrao(direcao: Vector2, velocidade_empurrao: float) -> void:
	if direcao == Vector2.ZERO:
		return

	var velocidade_alvo := minf(velocidade_empurrao, velocidade_maxima)
	velocity = direcao.normalized() * velocidade_alvo

func _physics_process(delta: float) -> void:
	move_and_slide()
	velocity = velocity.move_toward(Vector2.ZERO, desaceleracao * delta)
