extends StaticBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var colisao: CollisionShape2D = $CollisionShape2D
@onready var area_interacao: Area2D = $AreaInteracao

const TEXTURA_FECHADA = preload("res://Porta_Fechada.png")
const TEXTURA_ABERTA = preload("res://Porta_Aberta.png")

var jogador_no_alcance := false
var aberta := false

func _ready() -> void:
	sprite.texture = TEXTURA_FECHADA
	area_interacao.body_entered.connect(_on_body_entered)
	area_interacao.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		jogador_no_alcance = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		jogador_no_alcance = false

func _unhandled_input(event: InputEvent) -> void:
	if aberta or not jogador_no_alcance:
		return

	if event.is_action_pressed("interagir"):
		get_viewport().set_input_as_handled()
		_tentar_consertar()

func _tentar_consertar() -> void:
	if not Inventory.todos_componentes_coletados():
		Dialogo.mostrar("Ainda faltam componentes para consertar essa porta.", false)
		return

	Dialogo.mostrar_confirmacao(
		"Consertar utilizando os componentes coletados?",
		Callable(self, "_consertar_porta")
	)

func _consertar_porta() -> void:
	aberta = true
	name = "Porta_Aberta"
	sprite.texture = TEXTURA_ABERTA
	colisao.set_deferred("disabled", true)
	await get_tree().create_timer(0.7).timeout
	Dialogo.mostrar_tela_final()
