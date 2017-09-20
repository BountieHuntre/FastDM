AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_scoreboard.lua" )
AddCSLuaFile( "cl_chooseteam.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "cl_buymenu.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

local open = false

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
	
	if ( ply:GetPData( "C4" ) == nil ) then
		ply:SetNWBool( "C4", false )
	else
		ply:SetNWBool( "C4", true )
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
		attacker:SetNWInt( "playerExp", math.ceil( attacker:GetNWInt( "playerExp" ) + ( 100 * attacker:GetNWInt( "playerLevel" ) * 0.825 ) ) )
		attacker:SetNWInt( "playerKills", attacker:GetNWInt( "playerKills" ) + 1 )
	end
	
	checkForLevel( attacker )
end

function GM:CanPlayerSuicide( ply )
	if ply:Team() == TEAM_SPECTATOR or ply:Team() == TEAM_UNASSIGNED or ply:Team() == 1 or ply:Team() == 2 or ply:Team() == 3 then
		return false
	end
end

concommand.Add( "buyC4", function( sender, command, arguments ) 
	if not sender:IsValid() then return end
	local money = sender:GetNWInt( "playerMoney" )
	if sender:GetNWBool( "C4" ) != true then
		if tonumber( money ) < 1000 then
			sender:PrintMessage( HUD_PRINTTALK, "You do not have enough Money." )
		elseif tonumber( money ) >= 1000 then
			sender:SetNWInt( "playerMoney", tonumber( money ) - 1000 )
			sender:SetNWBool( "C4", true )
			sender:Give( "m9k_suicide_bomb" )
			sender:SelectWeapon( "m9k_suicide_bomb" )
		end
	else
		sender:Give( "m9k_suicide_bomb" )
	end
end)

function GM:PlayerLoadout( ply )
	if (ply:Team() == 1) or (ply:Team() == 2) or (ply:Team() == 3) or (ply:Team() == 25) then
	else
		if ply:GetNWBool( "C4" ) == true then
			ply:Give( "m9k_suicide_bomb" )
		end
		ply:Give( "m9k_m61_frag" )
		ply:SetAmmo( 0, ply:GetWeapon( "m9k_m61_frag" ):GetPrimaryAmmoType() )
		ply:Give( "m9k_machete" )
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
		ply:SetAmmo( 16, ply:GetWeapon( "m9k_1897winchester" ):GetPrimaryAmmoType() )
		
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
end

function GM:ShutDown()
	for k, v in pairs( player.GetAll() ) do
		v:SetPData( "playerLevel", v:GetNWInt( "playerLevel" ) )
		v:SetPData( "playerExp", v:GetNWInt( "playerExp" ) )
		v:SetPData( "playerMoney", v:GetNWInt( "playerMoney" ) )
		v:SetPData( "playerKills", v:GetNWInt( "playerKills" ) )
		v:SetPData( "C4", v:GetNWBool( "C4" ) )
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
	if ply:IsAdmin() or ply:IsSuperAdmin() then
		for k, v in pairs( player.GetAll() ) do
			v:SetPData( "playerLevel", 1 )
			v:SetPData( "playerExp", 0 )
			v:SetPData( "playerMoney", 0 )
			v:SetPData( "C4", false )
			v:SetNWInt( "playerLevel", 1 )
			v:SetNWInt( "playerExp", 0 )
			v:SetNWInt( "playerMoney", 0 )
			v:SetNWBool( "C4", false )
		end
	end
end
concommand.Add( "resetall", resetall )

function setlevel( ply, cmd, args )
	if ply:IsAdmin() or ply:IsSuperAdmin() then
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
	if ply:IsAdmin() or ply:IsSuperAdmin() then
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

function resetlevel( ply )
	ply:SetNWInt( "playerLevel", 1 )
	ply:SetNWInt( "playerExp", 0 )
	ply:SetNWInt( "playerMoney", 0 )
	ply:SetNWBool( "C4", false )
	ply:StripWeapons()
	ply:Spawn()
end
concommand.Add( "resetplayer", resetlevel )


function checkForLevel( ply )
	local etl = ( ply:GetNWInt( "playerLevel" ) * 100 ) * ( ply:GetNWInt( "playerLevel" ) * 1.2 )
	local cExp = ply:GetNWInt( "playerExp" )
	local cLvl = ply:GetNWInt( "playerLevel" )
	
	if ( tonumber(cExp) >= tonumber(etl) ) then
		cExp = cExp - etl
		
		ply:SetNWInt( "playerExp", cExp )
		ply:SetNWInt( "playerLevel", cLvl + 1 )
	end
end

