extends Area2D

@export var fase: String = "fase_1"
@export var distancia_ativacao := 24.0

@onready var sprite: Sprite2D = $Sprite2D

const TEXTURA_INATIVO = preload("res://botao_inativo.png")
const TEXTURA_ATIVO = preload("res://botao_ativo.png")

var ativado := false

func _ready() -> void:
	add_to_group("botao_pressao")
	add_to_group("botao_" + fase)
	collision_layer = 0
	collision_mask = 0
	set_collision_mask_value(2, true)
	_atualizar_visual()
	_verificar_estado()

func _physics_process(_delta: float) -> void:
	_verificar_estado()

func _verificar_estado() -> void:
	var novo_estado := _tem_caixa_sobre_botao()
	if novo_estado == ativado:
		return

	ativado = novo_estado
	_atualizar_visual()
	_atualizar_paredes_da_fase()

func _tem_caixa_sobre_botao() -> bool:
	for corpo in get_overlapping_bodies():
		if corpo.is_in_group("caixa"):
			return true

	for caixa in get_tree().get_nodes_in_group("caixa"):
		if caixa.global_position.distance_to(global_position) <= distancia_ativacao:
			return true

	return false

func _atualizar_visual() -> void:
	if ativado:
		sprite.texture = TEXTURA_ATIVO
	else:
		sprite.texture = TEXTURA_INATIVO

func _atualizar_paredes_da_fase() -> void:
	var todos_ativados := true
	for botao in get_tree().get_nodes_in_group("botao_" + fase):
		if not botao.ativado:
			todos_ativados = false
			break

	for parede in get_tree().get_nodes_in_group("parede_" + fase):
		if todos_ativados and parede.has_method("remover"):
			parede.remover()
		elif not todos_ativados and parede.has_method("restaurar"):
			parede.restaurar()
