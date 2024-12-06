extends Node

const ICON_PATH = "res://assets/Sprites/Items/Upgrades/"
const WEAPON_PATH = "res://assets/Sprites/Items/Weapons/"
const UPGRADES = {
	"icespear1": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Ice Spear",
		"details": "A spear of ice is thrown at a random enemy",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"icespear2": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Ice Spear",
		"details": "An additional Ice Spear is thrown",
		"level": "Level: 2",
		"prerequisite": ["icespear1"],
		"type": "weapon"
	},
	"icespear3": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Ice Spear",
		"details": "Ice Spears now pass through another enemy and do +3 more damage",
		"level": "Level: 3",
		"prerequisite": ["icespear2"],
		"type": "weapon"
	},
	"icespear4": {
		"icon": WEAPON_PATH + "ice_spear.png",
		"displayname": "Ice Spear",
		"details": "An additional 2 Ice Spears are thrown",
		"level": "Level: 4",
		"prerequisite": ["icespear3"],
		"type": "weapon"
	},
	"flyingsword1": {
		"icon": WEAPON_PATH + "", # Should be attack png
		"displayname": "Flying Sword",
		"details": "A magical Flying Sword will follow you and attack enemies in a straight line",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"flyingsword2": {
		"icon": WEAPON_PATH + "", # Should be attack png
		"displayname": "Flying Sword",
		"details": "The Flying Sword will now attack an additional enemy per attack",
		"level": "Level: 2",
		"prerequisite": ["flyingsword1"],
		"type": "weapon"
	},
	"flyingsword3": {
		"icon": WEAPON_PATH + "", # Should be attack png
		"displayname": "Flying Sword",
		"details": "The Flying Sword will attack another additional enemy per attack",
		"level": "Level: 3",
		"prerequisite": ["flyingsword2"],
		"type": "weapon"
	},
	"flyingsword4": {
		"icon": WEAPON_PATH + "", # Should be attack png
		"displayname": "Flying Sword",
		"details": "Increases Flying Sword damage by +5 per attack and increases knockback by 20%",
		"level": "Level: 4",
		"prerequisite": ["flyingsword3"],
		"type": "weapon"
	},
	"tornado1": {
		"icon": WEAPON_PATH + "tornado.png",
		"displayname": "Tornado",
		"details": "A tornado is created and heads in the direction the player is facing",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "weapon"
	},
	"tornado2": {
		"icon": WEAPON_PATH + "tornado.png",
		"displayname": "Tornado",
		"details": "An additional tornado is created",
		"level": "Level: 2",
		"prerequisite": ["tornado1"],
		"type": "weapon"
	},
	"tornado3": {
		"icon": WEAPON_PATH + "tornado.png",
		"displayname": "Tornado",
		"details": "Reduces tornado cooldown by 0.5 seconds",
		"level": "Level: 3",
		"prerequisite": ["tornado2"],
		"type": "weapon"
	},
	"tornado4": {
		"icon": WEAPON_PATH + "tornado.png",
		"displayname": "Tornado",
		"details": "An additional tornado is created and increases tornado knockback by 25%",
		"level": "Level: 4",
		"prerequisite": ["tornado3"],
		"type": "weapon"
	},
	"armor1": {
		"icon": ICON_PATH + "", #HERE
		"displayname": "Armor",
		"details": "Reduces Damage By 1 point",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"armor2": {
		"icon": ICON_PATH + "", #HERE
		"displayname": "Armor",
		"details": "Reduces Damage by an additional 1 point",
		"level": "Level: 2",
		"prerequisite": ["armor1"],
		"type": "upgrade"
	},
	"armor3": {
		"icon": ICON_PATH + "", #HERE
		"displayname": "Armor",
		"details": "Reduces Damage by an additional 1 point",
		"level": "Level: 3",
		"prerequisite": ["armor2"],
		"type": "upgrade"
	},
	"armor4": {
		"icon": ICON_PATH + "", #HERE
		"displayname": "Armor",
		"details": "Reduces Damage by an additional 1 point",
		"level": "Level: 4",
		"prerequisite": ["armor3"],
		"type": "upgrade"
	},
	"boots1": {
		"icon": ICON_PATH + "boot.png",
		"displayname": "Boots",
		"details": "Increases Movement Speed by 50% of base speed",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"boots2": {
		"icon": ICON_PATH + "boot.png",
		"displayname": "Boots",
		"details": "Increases Movement Speed by an additional 50%", #of base speed
		"level": "Level: 2",
		"prerequisite": ["boots1"],
		"type": "upgrade"
	},
	"boots3": {
		"icon": ICON_PATH + "boot.png",
		"displayname": "Boots",
		"details": "Increases Movement Speed by an additional 50%", #of base speed
		"level": "Level: 3",
		"prerequisite": ["boots2"],
		"type": "upgrade"
	},
	"boots4": {
		"icon": ICON_PATH + "boot.png",
		"displayname": "Boots",
		"details": "Increases Movement Speed by an additional 50%", #of base speed
		"level": "Level: 4",
		"prerequisite": ["boots3"],
		"type": "upgrade"
	},
	"tome1": {
		"icon": ICON_PATH + "tome.png",
		"displayname": "Tome",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"tome2": {
		"icon": ICON_PATH + "tome.png",
		"displayname": "Tome",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 2",
		"prerequisite": ["tome1"],
		"type": "upgrade"
	},
	"tome3": {
		"icon": ICON_PATH + "tome.png",
		"displayname": "Tome",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 3",
		"prerequisite": ["tome2"],
		"type": "upgrade"
	},
	"tome4": {
		"icon": ICON_PATH + "tome.png",
		"displayname": "Tome",
		"details": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 4",
		"prerequisite": ["tome3"],
		"type": "upgrade"
	},
	"hourglass1": {
		"icon": ICON_PATH + "hourglass.png",
		"displayname": "Hourglass",
		"details": "Decreases spell cooldown by 5%", #of their base time
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"hourglass2": {
		"icon": ICON_PATH + "hourglass.png",
		"displayname": "Hourglass",
		"details": "Decreases spell cooldown by an additional 5%", #of their base time
		"level": "Level: 2",
		"prerequisite": ["hourglass1"],
		"type": "upgrade"
	},
	"hourglass3": {
		"icon": ICON_PATH + "hourglass.png",
		"displayname": "Hourglass",
		"details": "Decreases spell cooldown by an additional 5%", #of their base time
		"level": "Level: 3",
		"prerequisite": ["hourglass2"],
		"type": "upgrade"
	},
	"hourglass4": {
		"icon": ICON_PATH + "hourglass.png",
		"displayname": "Hourglass",
		"details": "Decreases spell cooldown by an additional 5%", #of their base time
		"level": "Level: 4",
		"prerequisite": ["hourglass3"],
		"type": "upgrade"
	},
	"ring1": {
		"icon": ICON_PATH + "ring.png",
		"displayname": "Ring",
		"details": "Spells now spawn 1 more additional attack",
		"level": "Level: 1",
		"prerequisite": [],
		"type": "upgrade"
	},
	"ring2": {
		"icon": ICON_PATH + "ring.png",
		"displayname": "Ring",
		"details": "Spells now spawn an additional attack",
		"level": "Level: 2",
		"prerequisite": ["ring1"],
		"type": "upgrade"
	},
	"food": {
		"icon": ICON_PATH + "meat.png",
		"displayname": "Food",
		"details": "Heals you for 20 health",
		"level": "N/A",
		"prerequisite": [],
		"type": "item"
	}
	
}
