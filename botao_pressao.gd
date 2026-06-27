extends Area2D

@onready var sprite: Sprite2D = $Sprite2D

var ativado := false

var texture_inativo = preload("res://botao_inativo.png")
var texture_ativo = preload("res://botao_ativo.png")

func _ready() -> void:
	add_to_group("botao_pressao")
	sprite.texture = texture_inativo

func _physics_process(_delta: float) -> void:
	var tem_caixa := false

	for caixa in get_tree().get_nodes_in_group("caixa"):
		if caixa.global_position.distance_to(global_position) < 8.0:
			tem_caixa = true
			break

	if tem_caixa and not ativado:
		_ativar()
	elif not tem_caixa and ativado:
		_desativar()

func _ativar() -> void:
	ativado = true
	sprite.texture = texture_ativo
	_verificar_puzzle_completo()

func _desativar() -> void:
	ativado = false
	sprite.texture = texture_inativo

func _verificar_puzzle_completo() -> void:
	var botoes = get_tree().get_nodes_in_group("botao_pressao")
	var todos_ativados = botoes.all(func(b): return b.ativado)
	if todos_ativados:
		for parede in get_tree().get_nodes_in_group("parede_puzzle"):
			parede.remover()
