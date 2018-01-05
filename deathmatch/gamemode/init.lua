AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_scoreboard.lua" )
AddCSLuaFile( "cl_chooseteam.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "cl_buymenu.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

local open = false

local DefaultRunSpeed = 500
local DefaultWalkSpeed = 300

local RunDisable = 10

local StaminaDrainSpeed = 0.01
local StaminaRegenSpeed = 0.1

local maxLevel = 20

PLAYER = FindMetaTable( "Player" )

function PLAYER:Unassigned()
	if ( self:Team() == TEAM_UNASSIGNED or self:Team() == TEAM_SPECTATOR or self:Team() == 1 or self:Team() == 2 or self:Team() == 3 ) then
		return true
	end
	
	return false
end

function PLAYER:CanRespawn()
	if ( self:Unassigned() ) then
		return false
	end
	
	return true
end

function StaminaStart( ply )
	timer.Remove( "StaminaTimer" )
	ply:SetRunSpeed( DefaultRunSpeed )
	ply:SetNWInt( "Stamina", 100 )
	
	StaminaRegen( ply )
end
hook.Add( "PlayerSpawn", "StaminaStart", StaminaStart )

function StaminaPress( ply, key )
	if key == IN_SPEED or ply:KeyDown( IN_SPEED ) then
		if ply:GetMoveType() == MOVETYPE_NOCLIP then return end
		if ply:GetMoveType() == MOVETYPE_LADDER then return end
		if ply:GetNWInt( "Stamina" ) >= RunDisable then
			ply:SetRunSpeed( DefaultRunSpeed )
			timer.Remove( "StaminaRegen" )
			timer.Create( "StaminaTimer", StaminaDrainSpeed, 0, function( )
				if ply:GetNWInt( "Stamina" ) <= 0 then
					ply:SetRunSpeed( DefaultWalkSpeed )
					timer.Remove( "StaminaTimer" )
					return false
				end
				local vel = ply:GetVelocity()
				if vel.x >= DefaultWalkSpeed or vel.x <= -DefaultWalkSpeed or vel.y >= DefaultWalkSpeed or vel.y <= -DefaultWalkSpeed then
					ply:SetNWInt( "Stamina", ply:GetNWInt( "Stamina" ) - 1 )
				end
			end)
		else
			ply:SetRunSpeed( DefaultWalkSpeed )
			timer.Remove( "StaminaTimer" )
		end
	end
end
hook.Add( "KeyPress", "StaminaPress", StaminaPress ) 

function StaminaRelease( ply, key )
	if key == IN_SPEED and !ply:KeyDown( IN_SPEED ) then
		timer.Remove( "StaminaTimer" )
		StaminaRegen( ply )
	end
end
hook.Add( "KeyRelease", "StaminaRelease", StaminaRelease )

function StaminaRegen( ply )
	timer.Create( "StaminaGain", StaminaRegenSpeed, 0, function ( )
		if ply:GetNWInt( "Stamina" ) >= 100 then
			return false
		else
			ply:SetNWInt( "Stamina", math.Clamp( ply:GetNWInt( "Stamina" ) + 2, 0, 100 ) )
		end
	end)
end

function GM:PlayerSpawn( ply )
	if ( ply:Unassigned() ) then
		ply:StripAmmo()
		ply:StripWeapons()
		ply:Spectate( OBS_MODE_ROAMING )
		
		return false
	else
		ply:UnSpectate()
	end
	ply:RemoveAllAmmo()
	self.BaseClass:PlayerSpawn( ply )
end

function GM:PlayerInitialSpawn( ply )
	GAMEMODE:PlayerSpawnAsSpectator( ply )
	ply:PrintMessage( HUD_PRINTTALK, ply:Nick() .. " has joined the game." )
	ply:PrintMessage( HUD_PRINTTALK, "Press F1 to choose a team." )
	
	if ( ply:GetPData( "playerKills" ) == nil ) then
		ply:SetNWInt( "playerKills", 0 )
	else
		ply:SetNWInt( "playerKills", ply:GetPData( "playerKills" ) )
	end
	
	if ( ply:GetPData( "playerLevel" ) == nil ) then
		ply:SetNWInt( "playerLevel", 1 )
	else
		ply:SetNWInt( "playerLevel", ply:GetPData( "playerLevel" ) )
	end
	
	if ( ply:GetPData( "playerExp" ) == nil ) then
		ply:SetNWInt( "playerExp", 0 )
	else
		ply:SetNWInt( "playerExp", ply:GetPData( "playerExp" ) )
	end
	
	if ( ply:GetPData( "playerMoney" ) == nil ) then
		ply:SetNWInt( "playerMoney", 0 )
	else
		ply:SetNWInt( "playerMoney", ply:GetPData( "playerMoney" ) )
	end
	
	if ( tobool( ply:GetPData( "C4" ) ) == nil ) then
		ply:SetNWBool( "C4", false )
		ply:SetPData( "C4", false )
	else
		ply:SetNWBool( "C4", tobool( ply:GetPData( "C4" ) ) )
		ply:SetPData( "C4", tobool( ply:GetNWBool( "C4" ) ) )
	end
	if ( tobool( ply:GetPData( "Nitro" ) ) == nil ) then
		ply:SetNWBool( "Nitro", false )
		ply:SetPData( "Nitro", false )
	else
		ply:SetNWBool( "Nitro", tobool( ply:GetPData( "Nitro" ) ) )
		ply:SetPData( "Nitro", tobool( ply:GetNWBool( "Nitro" ) ) )
	end
	if ( tobool( ply:GetPData( "Sticky" ) ) == nil ) then
		ply:SetNWBool( "Sticky", false )
		ply:SetPData( "Sticky", false )
	else
		ply:SetNWBool( "Sticky", tobool( ply:GetPData( "Sticky" ) ) )
		ply:SetPData( "Sticky", tobool( ply:GetNWBool( "Sticky" ) ) )
	end
	if ( tobool( ply:GetPData( "Nerve" ) ) == nil ) then
		ply:SetNWBool( "Nerve", false )
		ply:SetPData( "Nerve", false )
	else
		ply:SetNWBool( "Nerve", tobool( ply:GetPData( "Nerve" ) ) )
		ply:SetPData( "Nerve", tobool( ply:GetNWBool( "Nerve" ) ) )
	end
	if ( tobool( ply:GetPData( "Sword" ) ) == nil ) then
		ply:SetNWBool( "Sword", false )
		ply:SetPData( "Sword", false )
	else
		ply:SetNWBool( "Sword", tobool( ply:GetPData( "Sword" ) ) )
		ply:SetPData( "Sword", tobool( ply:GetNWBool( "Sword" ) ) )
	end
	if ( tobool( ply:GetPData( "Machete" ) ) == nil ) then
		ply:SetNWBool( "Machete", true )
		ply:SetPData( "Machete", true )
	else
		ply:SetNWBool( "Machete", true )
		ply:SetPData( "Machete", true )
	end
	if ( tobool( ply:GetPData( "Pref" ) ) == nil ) then
		ply:SetNWBool( "Pref", true )
		ply:SetPData( "Pref", true )
	else
		ply:SetNWBool( "Pref", tobool( ply:GetPData( "Pref" ) ) )
		ply:SetPData( "Pref", tobool( ply:GetNWBool( "Pref" ) ) )
	end
	
	ply:ConCommand( "dm_start" )
end

function GM:PlayerSetModel( ply )
	if ( ply:Team() > 20 and ply:Team() < 26 ) then
		ply:SetModel( "models/player/phoenix.mdl" )
	elseif ( ply:Team() > 3 and ply:Team() < 9 ) then
		ply:SetModel( "models/player/riot.mdl" )
	end
end

function GM:GetFallDamage( ply, speed )
	return math.max( 0, math.ceil( 0.3218 * speed - 141.75 ) )
end


function GM:ShowHelp( ply )
	ply:ConCommand( "dm_start" )
end

function GM:ShowTeam( ply )
	ply:ConCommand( "dm_class" )
end

function GM:ShowSpare1( ply )
	ply:ConCommand( "buymenu" )
end

hook.Add( "PlayerCanHearPlayersVoice", "VoiceChat", function( listener, talker )
	return true
end)

function GM:PlayerShouldTakeDamage( victim, pl )
	if victim:IsPlayer() then
		if pl:IsPlayer() then
			if victim:Team() == 1 or victim:Team() == 2 or victim:Team() == 3 then
				return false
			else
				if victim:SteamID() == pl:SteamID() then
					return true
				else
					if pl:Team() == victim:Team() then
						return false
					else
						if ( 3 < tonumber( pl:Team() ) and tonumber( pl:Team() ) < 8 ) and ( 3 < tonumber( victim:Team() ) and tonumber( victim:Team() ) < 8 ) then
							return false
						else
							if ( 20 < tonumber( pl:Team() ) and tonumber( pl:Team() ) < 26 ) and ( 20 < tonumber( victim:Team() ) and tonumber( victim:Team() ) < 26 ) then
								return false
							else
								return true
							end
						end
					end
				end
			end
		else
			return false
		end
	end
	return true
end

function GM:OnNPCKilled( npc, attacker, inflictor )
	attacker:SetNWInt( "playerMoney", attacker:GetNWInt( "playerMoney" ) + 100 )
	attacker:SetNWInt( "playerExp", math.ceil( attacker:GetNWInt( "playerExp" ) + ( 100 * attacker:GetNWInt( "playerLevel" ) * 0.825 ) ) )
	
	checkForLevel( attacker )
end

function GM:PlayerDeath( victim, inflictor, attacker )
	self.BaseClass.PlayerDeath(self, victim, inflictor, attacker)
	if ( victim:Unassigned() ) then return end
	
	if attacker != victim then
		attacker:SetNWInt( "playerMoney", attacker:GetNWInt( "playerMoney" ) + ( 100 * ( victim:GetNWInt( "playerLevel" ) / 4 ) ) )
		if tonumber( attacker:GetNWInt( "playerLevel" ) ) < maxLevel then
			attacker:SetNWInt( "playerExp", math.ceil( attacker:GetNWInt( "playerExp" ) + ( 100 * attacker:GetNWInt( "playerLevel" ) * 0.825 ) ) )
		end
		attacker:SetNWInt( "playerKills", attacker:GetNWInt( "playerKills" ) + 1 )
	end
	
	checkForLevel( attacker )
end

function GM:CanPlayerSuicide( ply )
	if ply:Team() == TEAM_SPECTATOR or ply:Team() == TEAM_UNASSIGNED or ply:Team() == 1 or ply:Team() == 2 or ply:Team() == 3 then
		return false
	end
end

concommand.Add( "buyC4", function( ply, cmd, args ) 
	if not ply:IsValid() then return end
	local money = ply:GetNWInt( "playerMoney" )
	if ply:GetNWBool( "C4" ) != true then
		if tonumber( money ) < 10000 then
			ply:PrintMessage( HUD_PRINTTALK, "You do not have enough Money." )
		elseif tonumber( money ) >= 10000 then
			ply:SetNWInt( "playerMoney", tonumber( money ) - 10000 )
			ply:SetNWBool( "C4", true )
			ply:SetPData( "C4", true )
			ply:Give( "m9k_suicide_bomb" )
			ply:SelectWeapon( "m9k_suicide_bomb" )
		end
	else
		ply:Give( "m9k_suicide_bomb" )
		ply:SelectWeapon( "m9k_suicide_bomb" )
	end
end)

concommand.Add( "buyNitro", function( ply, cmd, args )
	if not ply:IsValid() then return end
	local money = ply:GetNWInt( "playerMoney" )
	if ply:GetNWBool( "Nitro" ) != true then
		if tonumber( money ) < 7000 then
			ply:PrintMessage( HUD_PRINTTALK, "You do not have enough Money." )
		elseif tonumber( money ) >= 7000 then
			ply:SetNWInt( "playerMoney", tonumber( money ) - 7000 )
			ply:SetNWBool( "Nitro", true )
			ply:SetPData( "Nitro", true )
			ply:Give( "m9k_nitro" )
			ply:SelectWeapon( "m9k_nitro" )
		end
	else
		ply:Give( "m9k_nitro" )
		ply:SelectWeapon( "m9k_nitro" )
	end
end)

concommand.Add( "buySticky", function( ply, cmd, args )
	if not ply:IsValid() then return end
	local money = ply:GetNWInt( "playerMoney" )
	if ply:GetNWBool( "Sticky" ) != true then
		if tonumber( money ) < 1000 then
			ply:PrintMessage( HUD_PRINTTALK, "You do not have enough Money." )
		elseif tonumber( money ) >= 1000 then
			ply:SetNWInt( "playerMoney", tonumber( money ) - 1000 )
			ply:SetNWBool( "Sticky", true )
			ply:SetPData( "Sticky", true )
			ply:Give( "m9k_sticky_grenade" )
			ply:SelectWeapon( "m9k_sticky_grenade" )
		end
	else
		ply:Give( "m9k_sticky_grenade" )
		ply:SelectWeapon( "m9k_sticky_grenade" )
	end
end)

concommand.Add( "buyNerve", function( ply, cmd, args )
	if not ply:IsValid() then return end
	local money = ply:GetNWInt( "playerMoney" )
	if ply:GetNWBool( "Nerve" ) != true then
		if tonumber( money ) < 500000 then
			ply:PrintMessage( HUD_PRINTTALK, "You do not have enough Money." )
		elseif tonumber( money ) >= 500000 then
			ply:SetNWInt( "playerMoney", tonumber( money ) - 500000 )
			ply:SetNWBool( "Nerve", true )
			ply:SetPData( "Nerve", true )
			ply:Give( "m9k_nerve_gas" )
			ply:SelectWeapon( "m9k_nerve_gas" )
		end
	else
		ply:Give( "m9k_nerve_gas" )
		ply:SelectWeapon( "m9k_nerve_gas" )
	end
end)

concommand.Add( "buySword", function( ply, cmd, args )
	if not ply:IsValid() then return end
	local money = ply:GetNWInt( "playerMoney" )
	if ply:GetNWBool( "Sword" ) != true then
		if tonumber( money ) < 5000 then
			ply:PrintMessage( HUD_PRINTTALK, "You do not have enough Money." )
		elseif tonumber( money ) >= 5000 then
			ply:SetNWInt( "playerMoney", tonumber( money ) - 5000 )
			ply:SetNWBool( "Sword", true )
			ply:SetPData( "Sword", true )
			ply:SetNWBool( "Pref", false )
			ply:SetPData( "Pref", false )
			ply:StripWeapon( "m9k_machete" )
			ply:Give( "m9k_damascus" )
			ply:SelectWeapon( "m9k_damascus" )
		end
	else
		ply:Give( "m9k_damascus" )
		ply:SelectWeapon( "m9k_damascus" )
	end
end)

concommand.Add( "buyMachete", function ( ply, cmd, args )
	if not ply:IsValid() then return end
	ply:SetNWBool( "Pref", true )
	ply:SetPData( "Pref", true )
	ply:StripWeapon( "m9k_damascus" )
	ply:Give( "m9k_machete" )
	ply:SelectWeapon( "m9k_machete" )
end)

function GM:PlayerLoadout( ply )
	if (ply:Team() == 1) or (ply:Team() == 2) or (ply:Team() == 3) or (ply:Team() == 25) then
	else
		if ply:GetNWBool( "C4" ) == true then
			ply:Give( "m9k_suicide_bomb" )
		end
		if ply:GetNWBool( "Nitro" ) == true then
			ply:Give( "m9k_nitro" )
		end
		if ply:GetNWBool( "Sticky" ) == true then
			ply:Give( "m9k_sticky_grenade" )
		end
		if ply:GetNWBool( "Nerve" ) == true then
			ply:Give( "m9k_nerve_gas" )
		end
		if ply:GetNWBool( "Pref" ) == true then
			ply:Give( "m9k_machete" )
		elseif ply:GetNWBool( "Sword" ) == true and ply:GetNWBool( "Pref" ) != true then
			ply:Give( "m9k_damascus" )
		else
			ply:Give( "m9k_machete" )
		end
		ply:Give( "m9k_m61_frag" )
		ply:SetAmmo( 0, ply:GetWeapon( "m9k_m61_frag" ):GetPrimaryAmmoType() )
	end
	
	if ply:Team() == 4 then
		ply:Give( "m9k_m4a1" )
		ply:SetAmmo( 120, ply:GetWeapon( "m9k_m4a1" ):GetPrimaryAmmoType() )
		
		ply:Give( "m9k_m92beretta" )
		ply:SetAmmo( 60, ply:GetWeapon( "m9k_m92beretta" ):GetPrimaryAmmoType() )
		
		ply:SelectWeapon( "m9k_m4a1" )
	end
	
	if ply:Team() == 5 then
		ply:Give( "m9k_remington870" )
		ply:SetAmmo( 32, ply:GetWeapon( "m9k_remington870" ):GetPrimaryAmmoType() )
		
		ply:Give( "m9k_m92beretta" )
		ply:SetAmmo( 60, ply:GetWeapon( "m9k_m92beretta" ):GetPrimaryAmmoType() )
		
		ply:Give( "weapon_medkit" )
		
		ply:SelectWeapon( "m9k_remington870" )
	end
	
	if ply:Team() == 6 then
		ply:Give( "m9k_m24" )
		ply:SetAmmo( 20, ply:GetWeapon( "m9k_m24" ):GetPrimaryAmmoType() )
		
		ply:Give( "m9k_m92beretta" )
		ply:SetAmmo( 60, ply:GetWeapon( "m9k_m92beretta" ):GetPrimaryAmmoType() )
		
		ply:SelectWeapon( "m9k_m24" )
	end
	
	if ply:Team() == 7 then
		ply:Give( "m9k_mp5" )
		ply:SetAmmo( 120, ply:GetWeapon( "m9k_mp5" ):GetPrimaryAmmoType() )
		
		ply:Give( "m9k_matador" )
		ply:SetAmmo( 2, ply:GetWeapon( "m9k_matador" ):GetPrimaryAmmoType() )
		
		ply:Give( "m9k_m92beretta" )
		ply:SetAmmo( 60, ply:GetWeapon( "m9k_m92beretta" ):GetPrimaryAmmoType() )
		
		ply:SelectWeapon( "m9k_mp5" )
	end
	
	if ply:Team() == 8 then
		ply:SetHealth( 300 )
		ply:SetMaxHealth( 300 )
		ply:Give( "m9k_minigun" )
		ply:SetAmmo( 0, ply:GetWeapon( "m9k_minigun" ):GetPrimaryAmmoType() )
		
		ply:Give( "m9k_orbital_strike" )
		ply:SetAmmo( 0, ply:GetWeapon( "m9k_orbital_strike" ):GetPrimaryAmmoType() )
		
		ply:SelectWeapon( "m9k_minigun" )
	end
	
	if ply:Team() == 21 then
		ply:Give( "m9k_ak47" )
		ply:SetAmmo( 120, ply:GetWeapon( "m9k_ak47" ):GetPrimaryAmmoType() )
		
		ply:Give( "m9k_sig_p229r" )
		ply:SetAmmo( 48, ply:GetWeapon( "m9k_sig_p229r" ):GetPrimaryAmmoType() )
		
		ply:SelectWeapon( "m9k_ak47" )
	end
	
	if ply:Team() == 22 then
		ply:Give( "m9k_1897winchester" )
		ply:SetAmmo( 32, ply:GetWeapon( "m9k_1897winchester" ):GetPrimaryAmmoType() )
		
		ply:Give( "m9k_sig_p229r" )
		ply:SetAmmo( 48, ply:GetWeapon( "m9k_sig_p229r" ):GetPrimaryAmmoType() )
		
		ply:Give( "weapon_medkit" )
		
		ply:SelectWeapon( "m9k_1897winchester" )
	end
	
	if ply:Team() == 23 then
		ply:Give( "m9k_m24" )
		ply:SetAmmo( 20, ply:GetWeapon( "m9k_m24" ):GetPrimaryAmmoType() )
		
		ply:Give( "m9k_sig_p229r" )
		ply:SetAmmo( 48, ply:GetWeapon( "m9k_sig_p229r" ):GetPrimaryAmmoType() )
		
		ply:SelectWeapon( "m9k_m24" )
	end
	
	if ply:Team() == 24 then
		ply:Give( "m9k_uzi" )
		ply:SetAmmo( 128, ply:GetWeapon( "m9k_uzi" ):GetPrimaryAmmoType() )
		
		ply:Give( "m9k_rpg7" )
		ply:SetAmmo( 2, ply:GetWeapon( "m9k_rpg7" ):GetPrimaryAmmoType() )
		
		ply:Give( "m9k_sig_p229r" )
		ply:SetAmmo( 48, ply:GetWeapon( "m9k_sig_p229r" ):GetPrimaryAmmoType() )
		
		ply:SelectWeapon( "m9k_uzi" )
	end
	
	if ply:Team() == 25 then
		ply:SetHealth( 300 )
		ply:SetMaxHealth( 300 )
		ply:Give( "m9k_minigun" )
		ply:SetAmmo( 0, ply:GetWeapon( "m9k_minigun" ):GetPrimaryAmmoType() )
		
		ply:Give( "m9k_orbital_strike" )
		ply:SetAmmo( 0, ply:GetWeapon( "m9k_orbital_strike" ):GetPrimaryAmmoType() )
		
		ply:SelectWeapon( "m9k_minigun" )
	end
end

function GM:PlayerDisconnected( ply )
	ply:SetPData( "playerLevel", ply:GetNWInt( "playerLevel" ) )
	ply:SetPData( "playerExp", ply:GetNWInt( "playerExp" ) )
	ply:SetPData( "playerMoney", ply:GetNWInt( "playerMoney" ) )
	ply:SetPData( "playerKills", ply:GetNWInt( "playerKills" ) )
	ply:SetPData( "C4", ply:GetNWBool( "C4" ) )
	ply:SetPData( "Nitro", ply:GetNWBool( "Nitro" ) )
	ply:SetPData( "Sticky", ply:GetNWBool( "Sticky" ) )
	ply:SetPData( "Nerve", ply:GetNWBool( "Nerve" ) )
	ply:SetPData( "Sword", ply:GetNWBool( "Sword" ) )
	ply:SetPData( "Machete", ply:GetNWBool( "Machete" ) )
	ply:SetPData( "Pref", ply:GetNWBool( "Pref" ) )
	ply:PrintMessage( HUD_PRINTTALK, ply:Nick() .. " has left the game." )
end

function GM:ShutDown()
	for k, v in pairs( player.GetAll() ) do
		v:SetPData( "playerLevel", v:GetNWInt( "playerLevel" ) )
		v:SetPData( "playerExp", v:GetNWInt( "playerExp" ) )
		v:SetPData( "playerMoney", v:GetNWInt( "playerMoney" ) )
		v:SetPData( "playerKills", v:GetNWInt( "playerKills" ) )
		v:SetPData( "C4", v:GetNWBool( "C4" ) )
		v:SetPData( "Nitro", v:GetNWBool( "Nitro" ) )
		v:SetPData( "Sticky", v:GetNWBool( "Sticky" ) )
		v:SetPData( "Nerve", v:GetNWBool( "Nerve" ) )
		v:SetPData( "Sword", v:GetNWBool( "Sword" ) )
		v:SetPData( "Machete", v:GetNWBool( "Machete" ) )
		v:SetPData( "Pref", v:GetNWBool( "Pref" ) )
	end
end

function showwep( ply )
	wep = ply:GetActiveWeapon()
	print( wep )
end
concommand.Add( "showwep", showwep )

function showammo( ply )
	ammo = ply:GetActiveWeapon():GetPrimaryAmmoType()
	print( ammo )
end
concommand.Add( "showammo", showammo )

function resetall( ply )
	if ply:IsAdmin() or ply:IsSuperAdmin() or ply:IsUserGroup("owner") then
		for k, v in pairs( player.GetAll() ) do
			v:SetPData( "playerKills", 0 )
			v:SetPData( "playerLevel", 1 )
			v:SetPData( "playerExp", 0 )
			v:SetPData( "playerMoney", 0 )
			v:SetPData( "C4", false )
			v:SetPData( "Nitro", false )
			v:SetPData( "Sticky", false )
			v:SetPData( "Nerve", false )
			v:SetPData( "Sword", false )
			v:SetPData( "Machete", true )
			v:SetPData( "Pref", true )
			v:SetNWInt( "playerKills", 0 )
			v:SetNWInt( "playerLevel", 1 )
			v:SetNWInt( "playerExp", 0 )
			v:SetNWInt( "playerMoney", 0 )
			v:SetNWBool( "C4", false )
			v:SetNWBool( "Nitro", false )
			v:SetNWBool( "Sticky", false )
			v:SetNWBool( "Nerve", false )
			v:SetNWBool( "Sword", false )
			v:SetNWBool( "Machete", true )
			v:SetNWBool( "Pref", true )
			v:StripWeapons()
			v:Spawn()
		end
	else
		ply:PrintMessage( HUD_PRINTTALK, "You are not allowed to use this command." )
	end
end
concommand.Add( "resetall", resetall )

function resetplayer( ply, cmd, args )
	if ply:IsAdmin() or ply:IsSuperAdmin() or ply:IsUserGroup("owner") then
		local target = NULL
		for k, v in pairs( player.GetAll() ) do
			if ( string.find( string.lower( v:GetName() ), string.lower( args[1] ) ) != nil ) then
				target = v
				break
			end
		end
		if IsValid( target ) then
			target:SetPData( "playerKills", 0 )
			target:SetPData( "playerLevel", 1 )
			target:SetPData( "playerExp", 0 )
			target:SetPData( "playerMoney", 0 )
			target:SetPData( "C4", false )
			target:SetPData( "Nitro", false )
			target:SetPData( "Sticky", false )
			target:SetPData( "Nerve", false )
			target:SetPData( "Sword", false )
			target:SetPData( "Machete", true )
			target:SetPData( "Pref", true )
			target:SetNWInt( "playerKills", 0 )
			target:SetNWInt( "playerLevel", 1 )
			target:SetNWInt( "playerExp", 0 )
			target:SetNWInt( "playerMoney", 0 )
			target:SetNWBool( "C4", false )
			target:SetNWBool( "Nitro", false )
			target:SetNWBool( "Sticky", false )
			target:SetNWBool( "Nerve", false )
			target:SetNWBool( "Sword", false )
			target:SetNWBool( "Machete", true )
			target:SetNWBool( "Pref", true )
			target:StripWeapons()
			target:Spawn()
		else
			print( "Couldn't find target with partial name: ", args[1] )
		end
	end
end
concommand.Add( "resetplayer", resetplayer )

function setlevel( ply, cmd, args )
	if ply:IsAdmin() or ply:IsSuperAdmin() or ply:IsUserGroup("owner") then
		local target = NULL
		for k, v in pairs( player.GetAll() ) do
			if ( string.find( string.lower( v:GetName() ), string.lower( args[1] ) ) != nil ) then
				target = v
				break
			end
		end
		if IsValid( target ) then
			if tonumber( args[2] ) > 0 then
				target:SetNWInt( "playerLevel", args[2] )
			else
				print( "Second argument must be greater than 0. " )
			end
		else
			print( "Couldn't find target with partial name: ", args[1] )
		end
	end
end
concommand.Add( "setlevel", setlevel )

function setteam( ply, cmd, args )
	if ply:IsAdmin() or ply:IsSuperAdmin() or ply:IsUserGroup("owner") then
		local target = NULL
		for k, v in pairs( player.GetAll() ) do
			if ( string.find( string.lower( v:GetName() ), string.lower( args[1] ) ) != nil ) then
				target = v
				break
			end
		end
		if IsValid( target ) then
			if tonumber( args[2] ) > 0 then
				target:SetTeam( args[2] )
				target:StripWeapons()
				target:Spawn()
			else
				print( "Second argument must be greater than 0. " )
			end
		else
			print( "Couldn't find target with partial name: ", args[1] )
		end
	end
end
concommand.Add( "setteam", setteam )

function setmoney( ply, cmd, args )
	if ply:IsAdmin() or ply:IsSuperAdmin() or ply:IsUserGroup( "owner" ) then
		local target = NULL
		for k, v in pairs( player.GetAll() ) do
			if ( string.find( string.lower( v:GetName() ), string.lower( args[1] ) ) != nil ) then
				target = v
				break
			end
		end
		if IsValid( target ) then
			if tonumber( args[2] ) > 0 then
				target:SetNWInt( "playerMoney", args[2] )
			else
				print( "Second argument must be greater than 0." )
			end
		else
			print( "Couldn't find target with partial name: ", args[1] )
		end
	end
end
concommand.Add( "setmoney", setmoney )

function givemoney( ply, cmd, args )
	if ply:IsAdmin() or ply:IsSuperAdmin() or ply:IsUserGroup( "owner" ) then
		local target = NULL
		for k, v in pairs( player.GetAll() ) do
			if ( string.find( string.lower( v:GetName() ), string.lower( args[1] ) ) != nil ) then
				target = v
				break
			end
		end
		if IsValid( target ) then
			if tonumber( args[2] ) > 0 then
				target:SetNWInt( "playerMoney", tonumber( target:GetNWInt( "playerMoney" ) ) + args[2] )
			else
				print( "Second argument must be greater than 0." )
			end
		else
			print( "Couldn't find target with partial name: ", args[1] )
		end
	end
end
concommand.Add( "givemoney", givemoney )

local teamCompCT = team.NumPlayers( 3 ) + team.NumPlayers( 4 ) + team.NumPlayers( 5 ) + team.NumPlayers( 8 ) + team.NumPlayers( 10 )
local teamCompT = team.NumPlayers( 2 ) + team.NumPlayers( 6 ) + team.NumPlayers( 7 ) + team.NumPlayers( 9 ) + team.NumPlayers( 11 ) + team.NumPlayers( 12 )
function dm_team1( ply )
	ply:SetTeam( 3 )
	ply:StripWeapons()
	PrintMessage( HUD_PRINTTALK, ply:GetName() .. " has joined Counter Terrorists." )
	ply:Spawn()
	ply:SetMaxHealth( 100 )
	ply:SetHealth( 100 )
end
concommand.Add( "dm_team1", dm_team1 )

function dm_team1_class1( ply )
	ply:SetTeam( 4 )
	ply:StripWeapons()
	ply:Spawn()
	ply:SetMaxHealth( 100 )
	ply:SetHealth( 100 )
end
concommand.Add( "dm_team1_class1", dm_team1_class1 )

function dm_team1_class2( ply )
	ply:SetTeam( 5 )
	ply:StripWeapons()
	ply:Spawn()
	ply:SetMaxHealth( 100 )
	ply:SetHealth( 100 )
end
concommand.Add( "dm_team1_class2", dm_team1_class2 )

function dm_team1_class3( ply )
	ply:SetTeam( 6 )
	ply:StripWeapons()
	ply:Spawn()
	ply:SetMaxHealth( 100 )
	ply:SetHealth( 100 )
end
concommand.Add( "dm_team1_class3", dm_team1_class3 )

function dm_team1_class4( ply )
	ply:SetTeam( 7 )
	ply:StripWeapons()
	ply:Spawn()
	ply:SetMaxHealth( 100 )
	ply:SetHealth( 100 )
end
concommand.Add( "dm_team1_class4", dm_team1_class4 )

function dm_team1_class5( ply )
	ply:SetTeam( 8 )
	ply:StripWeapons()
	ply:Spawn()
	ply:SetMaxHealth( 300 )
	ply:SetHealth( 300 )
end
concommand.Add( "dm_team1_class5", dm_team1_class5 )

function dm_team2( ply )
	ply:SetTeam( 2 )
	ply:StripWeapons()
	PrintMessage( HUD_PRINTTALK, ply:GetName() .. " has joined Terrorists." )
	ply:Spawn()
	ply:SetMaxHealth( 100 )
	ply:SetHealth( 100 )
end
concommand.Add( "dm_team2", dm_team2 )

function dm_team2_class1( ply )
	ply:SetTeam( 21 )
	ply:StripWeapons()
	ply:Spawn()
	ply:SetMaxHealth( 100 )
	ply:SetHealth( 100 )
end
concommand.Add( "dm_team2_class1", dm_team2_class1 )

function dm_team2_class2( ply )
	ply:SetTeam( 22 )
	ply:StripWeapons()
	ply:Spawn()
	ply:SetMaxHealth( 100 )
	ply:SetHealth( 100 )
end
concommand.Add( "dm_team2_class2", dm_team2_class2 )

function dm_team2_class3( ply )
	ply:SetTeam( 23 )
	ply:StripWeapons()
	ply:Spawn()
	ply:SetMaxHealth( 100 )
	ply:SetHealth( 100 )
end
concommand.Add( "dm_team2_class3", dm_team2_class3 )

function dm_team2_class4( ply )
	ply:SetTeam( 24 )
	ply:StripWeapons()
	ply:Spawn()
	ply:SetMaxHealth( 100 )
	ply:SetHealth( 100 )
end
concommand.Add( "dm_team2_class4", dm_team2_class4 )

function dm_team2_class5( ply )
	ply:SetTeam( 25 )
	ply:StripWeapons()
	ply:Spawn()
	ply:SetMaxHealth( 300 )
	ply:SetHealth( 300 )
end
concommand.Add( "dm_team2_class5", dm_team2_class5 )


function checkForLevel( ply )
	local etl = ( ply:GetNWInt( "playerLevel" ) * 100 ) * ( ply:GetNWInt( "playerLevel" ) * 1.2 )
	local cExp = ply:GetNWInt( "playerExp" )
	local cLvl = ply:GetNWInt( "playerLevel" )
	
	if ( tonumber(cExp) >= tonumber(etl) ) then
		cExp = cExp - etl
		
		ply:SetNWInt( "playerExp", cExp )
		ply:SetNWInt( "playerLevel", math.Clamp( cLvl + 1, 0, 20 ) )
	end
end

