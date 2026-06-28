extends CanvasLayer

var aberto := false
var paginas: Array[String] = []
var pagina_atual := -1

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

	mostrar(textos[componente_id])

func mostrar(texto_completo: String) -> void:
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
	imagem.show()
	painel.show()
	_avancar_texto()

func fechar() -> void:
	aberto = false
	texto.text = ""
	_esconder_interface()

func _unhandled_input(event: InputEvent) -> void:
	if not aberto:
		return

	if event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_SPACE:
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

func _esconder_interface() -> void:
	fundo.hide()
	imagem.hide()
	painel.hide()
