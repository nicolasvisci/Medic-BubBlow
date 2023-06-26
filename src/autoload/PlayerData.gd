extends Node

# Profilo medico
var name_user := ""
var surname_user := ""
var email := ""
var medic_code := ""

#Flag per caricamento dati Firebase
var game_mode := 0
var patients = []
var user_flag := 0 # Flag per identificare il paziente
var get_flag := 0 # Flag per caricamento dati
var first_mode := false # Flag prima modalita
var second_mode := false # Flag seconda modalita
var third_mode := false # Flag terza modalita
