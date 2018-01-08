local ply = FindMetaTable( "Player" )

teams = {}

teams[0] = {
				name = "Spectator",
				base = 0,
				color = Color( 125, 125, 125, 255 ),
				weps = {},
				ammo = {},
				maxHP = 100,
				model = ""
}

teams[1] = {
				name = "Counter Terrorists",
				base = 1,
				color = Color( 125, 125, 125, 255 ),
				weps = {},
				ammo = {},
				maxHP = 100,
				model = ""
}

teams[2] = {
				name = "Terrorists",
				base = 2,
				color = Color( 125, 125, 125, 255 ),
				weps = {},
				ammo = {},
				maxHP = 100,
				model = ""
}

// CT
teams[3] = {
				name = "Assault",
				base = 1,
				color = Color( 71, 130, 255, 255 ),
				hColor = Color( 21, 80, 205, 150 ),
				weps = { "fas2_g3", "fas2_glock20" },
				ammo = { 80, 60 },
				maxHP = 100,
				model = "models/player/riot.mdl"
}

teams[4] = {
				name = "Medic",
				base = 1,
				color = Color( 71, 130, 255, 255 ),
				hColor = Color( 21, 80, 205, 150 ),
				weps = { "fas2_m3s90", "fas2_glock20", "weapon_medkit" },
				ammo = { 32, 60, 0 },
				maxHP = 100,
				model = "models/player/riot.mdl"
}

teams[5] = {
				name = "Sniper",
				base = 1,
				color = Color( 71, 130, 255, 255 ),
				hColor = Color( 21, 80, 205, 150 ),
				weps = { "fas2_m24", "fas2_glock20" },
				ammo = { 20, 60 },
				maxHP = 100,
				model = "models/player/riot.mdl"
}

teams[6] = {
				name = "Specialist",
				base = 1,
				color = Color( 71, 130, 255, 255 ),
				hColor = Color( 21, 80, 205, 150 ),
				weps = { "fas2_mp5a5", "fas2_glock20", "m9k_matador" },
				ammo = { 120, 60, 2 },
				maxHP = 100,
				model = "models/player/riot.mdl"
}

teams[7] = {
				name = "Juggernaut",
				base = 1,
				color = Color( 71, 130, 255, 255 ),
				hColor = Color( 21, 80, 205, 150 ),
				weps = { "m9k_minigun", "fas2_glock20" },
				ammo = { 0, 60 },
				maxHP = 300,
				model = "models/player/riot.mdl"
}

// T
teams[8] = {
				name = "Assault",
				base = 2,
				color = Color( 250, 175, 0, 255 ),
				hColor = Color( 255, 175, 0, 150 ),
				weps = { "fas2_ak47", "fas2_p226" },
				ammo = { 124, 52 },
				maxHP = 100,
				model = "models/player/phoenix.mdl"
}

teams[9] = {
				name = "Medic",
				base = 2,
				color = Color( 250, 175, 0, 255 ),
				hColor = Color( 255, 175, 0, 150 ),
				weps = { "fas2_m3s90", "fas2_p226", "weapon_medkit" },
				ammo = { 32, 52, 0 },
				maxHP = 100,
				model = "models/player/phoenix.mdl"
}

teams[10] = {
				name = "Sniper",
				base = 2,
				color = Color( 250, 175, 0, 255 ),
				hColor = Color( 255, 175, 0, 150 ),
				weps = { "fas2_m24", "fas2_p226" },
				ammo = { 20, 52 },
				maxHP = 100,
				model = "models/player/phoenix.mdl"
}

teams[11] = {
				name = "Specialist",
				base = 2,
				color = Color( 250, 175, 0, 255 ),
				hColor = Color( 255, 175, 0, 150 ),
				weps = { "fas2_uzi", "fas2_p226", "m9k_rpg7" },
				ammo = { 128, 52, 2 },
				maxHP = 100,
				model = "models/player/phoenix.mdl"
}

teams[12] = {
				name = "Juggernaut",
				base = 2,
				color = Color( 250, 175, 0, 255 ),
				hColor = Color( 255, 175, 0, 150 ),
				weps = { "m9k_minigun", "fas2_p226" },
				ammo = { 0, 52 },
				maxHP = 300,
				model = "models/player/phoenix.mdl"
}
