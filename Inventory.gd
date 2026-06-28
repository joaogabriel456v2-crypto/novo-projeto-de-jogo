extends Node

var componentes := {
	"componente_1": {
		"partes_coletadas": {"parte_a": false, "parte_b": false},
		"craftado": false,
		"coletado": false,
		"sprite_parte_a": preload("res://sprites/componente1_parte_a.png"),
		"sprite_parte_b": preload("res://sprites/componente1_parte_b.png"),
		"sprite_montado": preload("res://sprites/componente1_montado.png"),
		"nome_exibicao": "Rele"
	},
	"componente_2": {
		"partes_coletadas": {"parte_a": false, "parte_b": false},
		"craftado": false,
		"coletado": false,
		"sprite_parte_a": preload("res://sprites/componente2_parte_a.png"),
		"sprite_parte_b": preload("res://sprites/componente2_parte_b.png"),
		"sprite_montado": preload("res://sprites/componente2_montado.png"),
		"nome_exibicao": "Valvula"
	},
	"componente_3": {
		"partes_coletadas": {"parte_a": false, "parte_b": false},
		"craftado": false,
		"coletado": false,
		"sprite_parte_a": preload("res://sprites/componente3_parte_a.png"),
		"sprite_parte_b": preload("res://sprites/componente3_parte_b.png"),
		"sprite_montado": preload("res://sprites/componente3_montado.png"),
		"nome_exibicao": "Componente 3"
	},
}

signal peca_coletada(componente_id: String, parte: String)
signal componente_coletado(componente_id: String)
signal componente_craftado(componente_id: String)

func coletar_peca(componente_id: String, parte: String) -> void:
	if not componentes.has(componente_id):
		push_warning("Componente desconhecido: " + componente_id)
		return

	componentes[componente_id]["partes_coletadas"][parte] = true
	peca_coletada.emit(componente_id, parte)

func coletar_componente(componente_id: String) -> void:
	if not componentes.has(componente_id):
		push_warning("Componente desconhecido: " + componente_id)
		return

	if componentes[componente_id]["coletado"]:
		return

	componentes[componente_id]["coletado"] = true
	componentes[componente_id]["craftado"] = true
	componentes[componente_id]["partes_coletadas"]["parte_a"] = true
	componentes[componente_id]["partes_coletadas"]["parte_b"] = true
	componente_coletado.emit(componente_id)

func componente_foi_coletado(componente_id: String) -> bool:
	if not componentes.has(componente_id):
		return false

	return componentes[componente_id]["coletado"]

func todos_componentes_coletados() -> bool:
	return (
		componente_foi_coletado("componente_1")
		and componente_foi_coletado("componente_2")
		and componente_foi_coletado("componente_3")
	)

func componente_esta_completo(componente_id: String) -> bool:
	var partes = componentes[componente_id]["partes_coletadas"]
	return partes["parte_a"] and partes["parte_b"] and not componentes[componente_id]["craftado"]

func listar_componentes_prontos_para_craft() -> Array:
	var prontos := []
	for id in componentes.keys():
		if componente_esta_completo(id):
			prontos.append(id)
	return prontos

func craftar(componente_id: String) -> void:
	if not componente_esta_completo(componente_id):
		push_warning("Componente nao esta completo: " + componente_id)
		return

	componentes[componente_id]["craftado"] = true
	componentes[componente_id]["coletado"] = true
	componente_coletado.emit(componente_id)
	componente_craftado.emit(componente_id)
