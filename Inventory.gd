extends Node

# ====== CONFIGURAÇÃO DOS COMPONENTES ======
# Cada componente tem um id (ex: "motor"), e duas peças: "parte_a" e "parte_b".
# Ajuste os nomes e os caminhos dos sprites conforme os seus arquivos.

var componentes := {
	"componente_1": {
		"partes_coletadas": {"parte_a": false, "parte_b": false},
		"craftado": false,
		"sprite_parte_a": preload("res://sprites/componente1_parte_a.png"),
		"sprite_parte_b": preload("res://sprites/componente1_parte_b.png"),
		"sprite_montado": preload("res://sprites/componente1_montado.png"),
		"nome_exibicao": "Componente 1"
	},
	"componente_2": {
		"partes_coletadas": {"parte_a": false, "parte_b": false},
		"craftado": false,
		"sprite_parte_a": preload("res://sprites/componente2_parte_a.png"),
		"sprite_parte_b": preload("res://sprites/componente2_parte_b.png"),
		"sprite_montado": preload("res://sprites/componente2_montado.png"),
		"nome_exibicao": "Componente 2"
	},
	"componente_3": {
		"partes_coletadas": {"parte_a": false, "parte_b": false},
		"craftado": false,
		"sprite_parte_a": preload("res://sprites/componente3_parte_a.png"),
		"sprite_parte_b": preload("res://sprites/componente3_parte_b.png"),
		"sprite_montado": preload("res://sprites/componente3_montado.png"),
		"nome_exibicao": "Componente 3"
	},
}

# Sinais para a UI escutar e se atualizar automaticamente
signal peca_coletada(componente_id: String, parte: String)
signal componente_craftado(componente_id: String)

func coletar_peca(componente_id: String, parte: String) -> void:
	if not componentes.has(componente_id):
		push_warning("Componente desconhecido: " + componente_id)
		return

	componentes[componente_id]["partes_coletadas"][parte] = true
	peca_coletada.emit(componente_id, parte)

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
		push_warning("Componente não está completo: " + componente_id)
		return

	componentes[componente_id]["craftado"] = true
	componente_craftado.emit(componente_id)
