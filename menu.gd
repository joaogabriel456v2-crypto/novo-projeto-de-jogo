extends CanvasLayer

const CENA_PRINCIPAL := "res://Cenário.tscn"

var aberto := false
var jogo_iniciado := false
var mostrando_creditos := false

@onready var fundo: TextureRect = TextureRect.new()
@onready var escurecer: ColorRect = ColorRect.new()
@onready var raiz: Control = Control.new()
@onready var coluna_menu: VBoxContainer = VBoxContainer.new()
@onready var titulo: Label = Label.new()
@onready var botao_jogar: Button = Button.new()
@onready var botao_creditos: Button = Button.new()
@onready var botao_reiniciar: Button = Button.new()
@onready var botao_sair: Button = Button.new()
@onready var painel_creditos: PanelContainer = PanelContainer.new()
@onready var texto_creditos: RichTextLabel = RichTextLabel.new()
@onready var botao_voltar: Button = Button.new()

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 500
	_criar_interface()
	abrir()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.physical_keycode == KEY_ALT:
		if aberto and mostrando_creditos:
			_mostrar_menu_principal()
		elif aberto and jogo_iniciado:
			_fechar_menu()
		else:
			abrir()
		get_viewport().set_input_as_handled()

func abrir() -> void:
	aberto = true
	show()
	get_tree().paused = true
	_mostrar_menu_principal()
	botao_jogar.grab_focus()

func _fechar_menu() -> void:
	aberto = false
	mostrando_creditos = false
	hide()
	get_tree().paused = false

func _jogar() -> void:
	if jogo_iniciado:
		_fechar_menu()
		return

	jogo_iniciado = true
	_fechar_menu()
	Introducao.iniciar()

func _reiniciar() -> void:
	aberto = false
	jogo_iniciado = true
	mostrando_creditos = false
	hide()
	get_tree().paused = false
	if Inventory.has_method("reiniciar"):
		Inventory.reiniciar()
	Introducao.reiniciar()
	if Dialogo.has_method("fechar"):
		Dialogo.fechar()
	get_tree().change_scene_to_file(CENA_PRINCIPAL)
	await get_tree().process_frame
	await get_tree().process_frame
	Introducao.iniciar()

func _sair() -> void:
	get_tree().quit()

func _abrir_creditos() -> void:
	mostrando_creditos = true
	coluna_menu.hide()
	painel_creditos.show()
	botao_voltar.grab_focus()

func _mostrar_menu_principal() -> void:
	mostrando_creditos = false
	painel_creditos.hide()
	coluna_menu.show()

func _criar_interface() -> void:
	fundo.set_anchors_preset(Control.PRESET_FULL_RECT)
	fundo.texture = preload("res://MENU.png")
	fundo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	fundo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	add_child(fundo)

	escurecer.set_anchors_preset(Control.PRESET_FULL_RECT)
	escurecer.color = Color(0, 0, 0, 0.36)
	add_child(escurecer)

	raiz.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(raiz)

	coluna_menu.set_anchors_preset(Control.PRESET_CENTER_LEFT)
	coluna_menu.offset_left = 64
	coluna_menu.offset_top = -180
	coluna_menu.offset_right = 390
	coluna_menu.offset_bottom = 180
	coluna_menu.alignment = BoxContainer.ALIGNMENT_CENTER
	coluna_menu.add_theme_constant_override("separation", 18)
	raiz.add_child(coluna_menu)

	titulo.text = "CHARLIE"
	titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	titulo.add_theme_color_override("font_color", Color.WHITE)
	titulo.add_theme_font_size_override("font_size", 54)
	coluna_menu.add_child(titulo)

	_configurar_botao(botao_jogar, "JOGAR")
	botao_jogar.pressed.connect(_jogar)
	coluna_menu.add_child(botao_jogar)

	_configurar_botao(botao_creditos, "CRÉDITOS")
	botao_creditos.pressed.connect(_abrir_creditos)
	coluna_menu.add_child(botao_creditos)

	_configurar_botao(botao_reiniciar, "REINICIAR")
	botao_reiniciar.pressed.connect(_reiniciar)
	coluna_menu.add_child(botao_reiniciar)

	_configurar_botao(botao_sair, "SAIR")
	botao_sair.pressed.connect(_sair)
	coluna_menu.add_child(botao_sair)

	_criar_creditos()

func _configurar_botao(botao: Button, texto: String) -> void:
	botao.text = texto
	botao.custom_minimum_size = Vector2(300, 64)
	botao.focus_mode = Control.FOCUS_ALL
	botao.add_theme_font_size_override("font_size", 32)
	botao.add_theme_color_override("font_color", Color.WHITE)
	botao.add_theme_color_override("font_focus_color", Color.WHITE)
	botao.add_theme_color_override("font_hover_color", Color.WHITE)
	botao.add_theme_color_override("font_pressed_color", Color.WHITE)

	botao.add_theme_stylebox_override("normal", _criar_estilo_botao(Color(0.02, 0.02, 0.02, 0.92), Color.WHITE))
	botao.add_theme_stylebox_override("focus", _criar_estilo_botao(Color(0.08, 0.08, 0.08, 0.96), Color.WHITE))
	botao.add_theme_stylebox_override("hover", _criar_estilo_botao(Color(0.12, 0.12, 0.12, 0.96), Color.WHITE))
	botao.add_theme_stylebox_override("pressed", _criar_estilo_botao(Color(0.18, 0.18, 0.18, 0.98), Color.WHITE))

func _criar_estilo_botao(cor_fundo: Color, cor_borda: Color) -> StyleBoxFlat:
	var estilo := StyleBoxFlat.new()
	estilo.bg_color = cor_fundo
	estilo.border_color = cor_borda
	estilo.set_border_width_all(4)
	estilo.set_corner_radius_all(0)
	estilo.content_margin_left = 18
	estilo.content_margin_top = 10
	estilo.content_margin_right = 18
	estilo.content_margin_bottom = 10
	return estilo

func _criar_creditos() -> void:
	painel_creditos.set_anchors_preset(Control.PRESET_FULL_RECT)
	painel_creditos.offset_left = 54
	painel_creditos.offset_top = 38
	painel_creditos.offset_right = -54
	painel_creditos.offset_bottom = -38
	painel_creditos.add_theme_stylebox_override("panel", _criar_estilo_creditos())
	raiz.add_child(painel_creditos)

	var caixa := VBoxContainer.new()
	caixa.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	caixa.size_flags_vertical = Control.SIZE_EXPAND_FILL
	caixa.add_theme_constant_override("separation", 14)
	painel_creditos.add_child(caixa)

	texto_creditos.bbcode_enabled = true
	texto_creditos.fit_content = false
	texto_creditos.scroll_active = true
	texto_creditos.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	texto_creditos.size_flags_vertical = Control.SIZE_EXPAND_FILL
	texto_creditos.add_theme_color_override("default_color", Color.WHITE)
	texto_creditos.add_theme_font_size_override("normal_font_size", 24)
	texto_creditos.text = _texto_creditos()
	caixa.add_child(texto_creditos)

	_configurar_botao(botao_voltar, "VOLTAR")
	botao_voltar.custom_minimum_size = Vector2(220, 54)
	botao_voltar.pressed.connect(_mostrar_menu_principal)
	caixa.add_child(botao_voltar)

func _criar_estilo_creditos() -> StyleBoxFlat:
	var estilo := StyleBoxFlat.new()
	estilo.bg_color = Color(0.02, 0.02, 0.02, 0.94)
	estilo.border_color = Color.WHITE
	estilo.set_border_width_all(4)
	estilo.set_corner_radius_all(0)
	estilo.content_margin_left = 24
	estilo.content_margin_top = 20
	estilo.content_margin_right = 24
	estilo.content_margin_bottom = 20
	return estilo

func _texto_creditos() -> String:
	return """[center][font_size=36]CRÉDITOS[/font_size][/center]

[font_size=28]DESENVOLVIMENTO DO PROJETO[/font_size]

[font_size=26]PROGRAMAÇÃO PRINCIPAL E LIDERANÇA TÉCNICA[/font_size]
[b]JOÃO GABRIEL ALMEIDA BARBOSA[/b]

* RESPONSÁVEL PELA MAIOR PARTE DA PROGRAMAÇÃO DO JOGO.
* DEFINIÇÃO DA PLATAFORMA E DAS TECNOLOGIAS UTILIZADAS NO DESENVOLVIMENTO.
* IMPLEMENTAÇÃO DOS PRINCIPAIS SISTEMAS E MECÂNICAS DO JOGO.
* DESENVOLVIMENTO DO CENÁRIO.
* ANIMAÇÃO DA PERSONAGEM CHARLIE.
* DESENVOLVIMENTO DA HISTÓRIA.
* CRIAÇÃO DA PERSONAGEM.
* MONTAGEM DOS COMPONENTES.

[font_size=26]DESENVOLVIMENTO[/font_size]
[b]CAIO VINÍCIUS HENCKES MELO[/b]
* DESENVOLVIMENTO DA HISTÓRIA.
* CRIAÇÃO DO ROTEIRO.
* CRIAÇÃO DA PERSONAGEM.
* CRIAÇÃO DO MENU.
* MONTAGEM DOS COMPONENTES.

[b]GABRIEL MARQUES RODRIGUES DA SILVA[/b]
* DESENVOLVIMENTO DA HISTÓRIA.
* CRIAÇÃO DO ROTEIRO.
* CRIAÇÃO DO MENU.
* CRIAÇÃO DOS BALÕES DE DIÁLOGO.
* CRIAÇÃO DA PERSONAGEM.
* MONTAGEM DOS COMPONENTES.

[b]JOÃO PAULO DE OLIVEIRA XAVIER[/b]
* DESENVOLVIMENTO DA HISTÓRIA.
* CRIAÇÃO DA PERSONAGEM.
* MONTAGEM DOS COMPONENTES.

[font_size=28]HISTÓRIA[/font_size]
DESENVOLVIMENTO DA HISTÓRIA:
* CAIO VINÍCIUS HENCKES MELO
* JOÃO GABRIEL ALMEIDA BARBOSA
* GABRIEL MARQUES RODRIGUES DA SILVA
* JOÃO PAULO DE OLIVEIRA XAVIER

[font_size=28]ORIENTAÇÃO[/font_size]
[b]PROF.ª THAÍS GAUDENCIO DO RÊGO[/b]
DISCIPLINA: [b]INTRODUÇÃO À CIÊNCIA DA COMPUTAÇÃO[/b]

[font_size=26]AGRADECIMENTOS[/font_size]
ESTE PROJETO FOI DESENVOLVIDO COMO PARTE DA DISCIPLINA [b]INTRODUÇÃO À CIÊNCIA DA COMPUTAÇÃO[/b]. AGRADECEMOS À PROF.ª [b]THAÍS GAUDENCIO DO RÊGO[/b] PELA ORIENTAÇÃO E APOIO DURANTE SUA REALIZAÇÃO.

[center][b]OBRIGADO POR JOGAR![/b][/center]"""
