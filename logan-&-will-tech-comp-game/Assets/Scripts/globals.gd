extends Node

var xp = 0
var maxxp = 1
var level = 0
var playerBody: CharacterBody2D
var playerAlive = true
var playerDamageSword: int
var playerDamageSpell1 = 5
var playerhitbox: Area2D
var playerDamageZone: Area2D	
var playerDamageAmount: int

#Stats
var str = 10
var vig = 10
var vit = 10
var wis = 10
var regen = (vit/2)
var stamregen = (vit/0.75)

#slime enemy
var slimecanhit: bool
var slimedamagezone: Area2D	
var slimedamageamount: int
var slimeBody: CharacterBody2D

var transitionOut: bool
var timesEntered = 1
func level_up():
	if Globals.xp >= Globals.maxxp:
		Globals.level += 1
		Globals.xp -= Globals.maxxp
		if Globals.level == 1:
			Globals.maxxp = 0
			Globals.maxxp += (Globals.level * 5)
		else:
			Globals.maxxp += (Globals.level * 5)
