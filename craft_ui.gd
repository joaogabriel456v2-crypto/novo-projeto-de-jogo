extends CanvasLayer

var aberto := false

@onready var painel: PanelContainer = $Painel
@onready var botao_rele = $Painel/Control/VBoxContainer/BotaoRele
@onready var botao_valvula = $Painel/Control/VBoxContainer/BotaoValvula
@onready var botao_transistor = $Painel/Control/VBoxContainer/BotaoTransistor
@onready var detalhes_rele = $Painel/Control/DetalhesRele
@onready var detalhes_valvula = $Painel/Control/DetalhesValvula
@onready var detalhes_transistor = $Painel/Control/DetalhesTransistor
@onready var criar_rele: TextureButton = $Painel/Control/DetalhesRele/Button
@onready var criar_valvula: TextureButton = $Painel/Control/DetalhesValvula/Button
@onready var criar_transistor: TextureButton = $Painel/Control/DetalhesTransistor/Button
@onready var botao_fechar = $Painel/Control/BotaoFechar

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	painel.hide()

	botao_rele.pressed.connect(func(): _selecionar("rele"))
	botao_valvula.pressed.connect(func(): _selecionar("valvula"))
	botao_transistor.pressed.connect(func(): _selecionar("transistor"))

	criar_rele.pressed.connect(func(): _craftar("componente_1"))
	criar_valvula.pressed.connect(func(): _craftar("componente_2"))
	criar_transistor.pressed.connect(func(): _craftar("componente_3"))

	botao_fechar.pressed.connect(fechar)
	botao_fechar.add_theme_color_override("font_color", Color(1, 0, 0, 1))

func abrir() -> void:
	aberto = true
	detalhes_rele.hide()
	detalhes_valvula.hide()
	detalhes_transistor.hide()
	_atualizar_botoes_criar()
	painel.show()

func fechar() -> void:
	aberto = false
	painel.hide()

func _selecionar(qual: String) -> void:
	detalhes_rele.hide()
	detalhes_valvula.hide()
	detalhes_transistor.hide()

	if qual == "rele":
		detalhes_rele.show()
	elif qual == "valvula":
		detalhes_valvula.show()
	elif qual == "transistor":
		detalhes_transistor.show()

func _atualizar_botoes_criar() -> void:
	_atualizar_botao(criar_rele, "componente_1")
	_atualizar_botao(criar_valvula, "componente_2")
	_atualizar_botao(criar_transistor, "componente_3")

func _atualizar_botao(botao: TextureButton, comp_id: String) -> void:
	var craftado = Inventory.componentes[comp_id]["craftado"]
	var completo = Inventory.componente_esta_completo(comp_id)

	if craftado:
		botao.disabled = true
		botao.modulate = Color(0.5, 0.5, 0.5)
	elif completo:
		botao.disabled = false
		botao.modulate = Color(1.0, 1.0, 1.0)  # cor normal
	else:
		botao.disabled = true
		botao.modulate = Color(0.5, 0.5, 0.5)

func _craftar(comp_id: String) -> void:
	if not Inventory.componente_esta_completo(comp_id):
		return

	Inventory.craftar(comp_id)
	_atualizar_botoes_criar()
	fechar()
	Dialogo.mostrar_componente(comp_id)
