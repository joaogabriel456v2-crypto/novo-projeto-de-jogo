extends CanvasLayer

var aberto := false
var paginas: Array[String] = []
var pagina_atual := -1
var em_confirmacao := false
var final_aberto := false
var confirmacao_callback := Callable()

var textos := {
	"componente_1": """Hm? O que é isso? Olha só! Um relé!
Pelo visto é bem antigo, mas ainda está inteiro.
Ele funciona como um interruptor que é acionado por um eletroímã.
Quando ele recebe corrente, ou ele fecha e interrompe a corrente ou abre e deixa passar.
Ele é bem lentinho, mas é bastante resistente!
Para a época dele foi um avanço enorme mesmo assim.""",
	"componente_2": """Caramba! Eu acho que isso aqui é uma válvula termiônica!
Se não me engano, ela é feita de uma ampola de vidro com alguns filamentos selados a vácuo.
Ela controla e amplifica corrente elétrica, mas diferente do relé, nenhuma peça se mexe.
Como ela é feita de tungstênio ela acaba esquentando muito, igual as lâmpadas incandescentes.
A maior diferença dela para o relé é que ela trabalha em silêncio, mas é MUITO maior e basta uma queda para dar adeus.""",
	"componente_3": """Espera... Não acredito! Quais as chances de eu ter encontrado nesse lugar os três principais componentes na criação dos computadores ao longo do tempo!
Isso aqui só pode ser um transistor. Olha só como é pequeno!
Ele é feito de silício, que é semicondutor.
Foi ele que permitiu que os circuitos diminuíssem tanto, permitindo a criação de celulares e laptops.
Enquanto o relé usa força mecânica e a válvula usa elétrons viajando no vácuo, esse carinha faz o trabalho dos dois sendo do tamanho de uma formiga!
Tenho certeza que no meu laptop deve ter alguns milhões desses lá dentro!"""
}

var imagens := {
	"componente_1": "res://sprites/componente1_montado.png",
	"componente_2": "res://sprites/componente2_montado.png",
	"componente_3": "res://sprites/componente3_montado.png"
}

@onready var fundo: ColorRect = ColorRect.new()
@onready var imagem: TextureRect = TextureRect.new()
@onready var painel: PanelContainer = PanelContainer.new()
@onready var texto: Label = Label.new()
@onready var painel_confirmacao: PanelContainer = PanelContainer.new()
@onready var texto_confirmacao: Label = Label.new()
@onready var botao_sim: Button = Button.new()
@onready var botao_nao: Button = Button.new()
@onready var tela_final: ColorRect = ColorRect.new()
@onready var texto_final: Label = Label.new()

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 100
	_criar_interface()
	_esconder_interface()

func mostrar_componente(componente_id: String) -> void:
	if not textos.has(componente_id):
		return

	if imagens.has(componente_id):
		imagem.texture = load(imagens[componente_id])
	else:
		imagem.texture = null

	mostrar(textos[componente_id], true)

func mostrar_confirmacao(texto_pergunta: String, ao_confirmar: Callable) -> void:
	aberto = true
	em_confirmacao = true
	confirmacao_callback = ao_confirmar
	texto_confirmacao.text = texto_pergunta

	fundo.show()
	imagem.hide()
	painel.hide()
	painel_confirmacao.show()
	botao_sim.grab_focus()

func mostrar_tela_final() -> void:
	aberto = true
	em_confirmacao = false
	final_aberto = true
	texto_final.text = "Obrigado por jogar\nSeu tempo: " + _obter_tempo_final()
	fundo.hide()
	imagem.hide()
	painel.hide()
	painel_confirmacao.hide()
	tela_final.show()

func _obter_tempo_final() -> String:
	for timer in get_tree().get_nodes_in_group("timer_ui"):
		if timer.has_method("parar"):
			timer.parar()
		if timer.has_method("obter_tempo_formatado"):
			return timer.obter_tempo_formatado()

	return "0.00s"

func mostrar(texto_completo: String, mostrar_imagem := false) -> void:
	paginas.clear()
	for linha in texto_completo.split("\n"):
		var pagina := linha.strip_edges()
		if not pagina.is_empty():
			paginas.append(pagina)

	if paginas.is_empty():
		return

	aberto = true
	pagina_atual = -1
	fundo.show()
	if mostrar_imagem and imagem.texture:
		imagem.show()
	else:
		imagem.hide()
	painel.show()
	_avancar_texto()

func fechar() -> void:
	aberto = false
	em_confirmacao = false
	final_aberto = false
	texto.text = ""
	_esconder_interface()

func _unhandled_input(event: InputEvent) -> void:
	if not aberto:
		return

	if em_confirmacao:
		return

	if event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_SPACE:
		if final_aberto:
			fechar()
			Menu.abrir()
		else:
			_avancar_texto()
		get_viewport().set_input_as_handled()

func _avancar_texto() -> void:
	pagina_atual += 1
	if pagina_atual >= paginas.size():
		fechar()
		return

	texto.text = paginas[pagina_atual]

func _criar_interface() -> void:
	fundo.set_anchors_preset(Control.PRESET_FULL_RECT)
	fundo.color = Color(0, 0, 0, 0.72)
	add_child(fundo)

	imagem.set_anchors_preset(Control.PRESET_CENTER_TOP)
	imagem.offset_left = -170
	imagem.offset_top = 38
	imagem.offset_right = 170
	imagem.offset_bottom = 270
	imagem.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	imagem.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	add_child(imagem)

	painel.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	painel.offset_left = 32
	painel.offset_top = -182
	painel.offset_right = -32
	painel.offset_bottom = -32
	add_child(painel)

	var estilo := StyleBoxFlat.new()
	estilo.bg_color = Color(0.02, 0.02, 0.02, 0.94)
	estilo.border_color = Color.WHITE
	estilo.set_border_width_all(4)
	estilo.set_corner_radius_all(0)
	estilo.content_margin_left = 22
	estilo.content_margin_top = 18
	estilo.content_margin_right = 22
	estilo.content_margin_bottom = 18
	painel.add_theme_stylebox_override("panel", estilo)

	texto.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	texto.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	texto.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	texto.size_flags_vertical = Control.SIZE_EXPAND_FILL
	texto.add_theme_color_override("font_color", Color.WHITE)
	texto.add_theme_font_size_override("font_size", 24)
	painel.add_child(texto)

	_criar_confirmacao(estilo)
	_criar_tela_final()

func _criar_confirmacao(estilo: StyleBoxFlat) -> void:
	painel_confirmacao.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	painel_confirmacao.offset_left = 32
	painel_confirmacao.offset_top = -182
	painel_confirmacao.offset_right = -32
	painel_confirmacao.offset_bottom = -32
	painel_confirmacao.add_theme_stylebox_override("panel", estilo.duplicate())
	add_child(painel_confirmacao)

	var caixa := VBoxContainer.new()
	caixa.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	caixa.size_flags_vertical = Control.SIZE_EXPAND_FILL
	painel_confirmacao.add_child(caixa)

	texto_confirmacao.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	texto_confirmacao.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	texto_confirmacao.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	texto_confirmacao.size_flags_vertical = Control.SIZE_EXPAND_FILL
	texto_confirmacao.add_theme_color_override("font_color", Color.WHITE)
	texto_confirmacao.add_theme_font_size_override("font_size", 24)
	caixa.add_child(texto_confirmacao)

	var botoes := HBoxContainer.new()
	botoes.alignment = BoxContainer.ALIGNMENT_CENTER
	botoes.add_theme_constant_override("separation", 24)
	caixa.add_child(botoes)

	botao_sim.text = "Sim"
	botao_sim.custom_minimum_size = Vector2(120, 42)
	botao_sim.pressed.connect(_confirmar)
	botoes.add_child(botao_sim)

	botao_nao.text = "Nao"
	botao_nao.custom_minimum_size = Vector2(120, 42)
	botao_nao.pressed.connect(_cancelar_confirmacao)
	botoes.add_child(botao_nao)

func _criar_tela_final() -> void:
	tela_final.set_anchors_preset(Control.PRESET_FULL_RECT)
	tela_final.color = Color.BLACK
	tela_final.z_index = 1000
	add_child(tela_final)

	texto_final.set_anchors_preset(Control.PRESET_FULL_RECT)
	texto_final.text = "Obrigado por jogar"
	texto_final.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	texto_final.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	texto_final.add_theme_color_override("font_color", Color.WHITE)
	texto_final.add_theme_font_size_override("font_size", 38)
	tela_final.add_child(texto_final)

func _confirmar() -> void:
	var callback := confirmacao_callback
	confirmacao_callback = Callable()
	fechar()
	if callback.is_valid():
		callback.call()

func _cancelar_confirmacao() -> void:
	confirmacao_callback = Callable()
	fechar()

func _esconder_interface() -> void:
	fundo.hide()
	imagem.hide()
	painel.hide()
	painel_confirmacao.hide()
	tela_final.hide()
