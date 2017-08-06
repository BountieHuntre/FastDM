AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "cl_scoreboard.lua" )
AddCSLuaFile( "cl_chooseteam.lua" )
AddCSLuaFile( "cl_hud.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function GM:PlayerSpawn( ply )
	ply:RemoveAllAmmo()
	self.BaseClass:PlayerSpawn( ply )
	
end

function GM:PlayerInitialSpawn( ply )
	ply:SetTeam( 1 )
	ply:SetModel( "models/player/group01/male_01.mdl" )
	ply:PrintMessage( HUD_PRINTTALK, ply:Nick() .. " has joined the game." )
	ply:PrintMessage( HUD_PRINTTALK, "Press F1 to choose a team." )
	
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
end

function GM:PlayerSetModel( ply )
	if ( ply:Team() == 2 ) then
		ply:SetModel( "models/player/phoenix.mdl" )
	elseif ( ply:Team() == 3 ) then
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

function GM:PlayerShouldTakeDamage( victim, pl )
	if victim:IsPlayer() then
		if pl:IsPlayer() then
			if pl == victim then
				return true
			elseif victim:Team() == 1 or pl:Team() == victim:Team() then
				return false
			else
				return true
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
	
	if attacker != victim then
		attacker:SetNWInt( "playerExp", math.ceil( attacker:GetNWInt( "playerExp" ) * ( 100 * attacker:GetNWInt( "playerLevel" ) * 0.825 ) ) )
	end
	
	checkForLevel( attacker )
end

function GM:PlayerLoadout( ply )
	if (ply:Team() == 1) or (ply:Team() == 2) or (ply:Team() == 3) or (ply:Team() == 12) then
	else
		ply:Give( "m9k_m61_frag" )
		ply:SetAmmo( 0, ply:GetWeapon( "m9k_m61_frag" ):GetPrimaryAmmoType() )
		ply:Give( "m9k_machete" )
	end
	
	if ply:Team() == 4 then
		ply:Give( "m9k_m4a1" )
		ply:SetAmmo( 120, ply:GetWeapon( "m9k_m4a1" ):GetPrimaryAmmoType() )
		ply:SelectWeapon( "m9k_m4a1" )
		
		ply:Give( "m9k_m92beretta" )
		ply:SetAmmo( 60, ply:GetWeapon( "m9k_m92beretta" ):GetPrimaryAmmoType() )
	end
	
	if ply:Team() == 5 then
		ply:Give( "m9k_remington870" )
		ply:SetAmmo( 32, ply:GetWeapon( "m9k_remington870" ):GetPrimaryAmmoType() )
		ply:SelectWeapon( "m9k_remington870" )
		
		ply:Give( "m9k_m92beretta" )
		ply:SetAmmo( 60, ply:GetWeapon( "m9k_m92beretta" ):GetPrimaryAmmoType() )
		
		ply:Give( "weapon_medkit" )
	end
	
	if ply:Team() == 8 then
		ply:Give( "m9k_m24" )
		ply:SetAmmo( 20, ply:GetWeapon( "m9k_m24" ):GetPrimaryAmmoType() )
		ply:SelectWeapon( "m9k_m24" )
		
		ply:Give( "m9k_m92beretta" )
		ply:SetAmmo( 60, ply:GetWeapon( "m9k_m92beretta" ):GetPrimaryAmmoType() )
	end
	
	if ply:Team() == 10 then
		ply:Give( "m9k_mp5" )
		ply:SetAmmo( 120, ply:GetWeapon( "m9k_mp5" ):GetPrimaryAmmoType() )
		ply:SelectWeapon( "m9k_mp5" )
		
		ply:Give( "m9k_matador" )
		ply:SetAmmo( 2, ply:GetWeapon( "m9k_matador" ):GetPrimaryAmmoType() )
		
		ply:Give( "m9k_m92beretta" )
		ply:SetAmmo( 60, ply:GetWeapon( "m9k_m92beretta" ):GetPrimaryAmmoType() )
	end
	
	if ply:Team() == 6 then
		ply:Give( "m9k_ak47" )
		ply:SetAmmo( 120, ply:GetWeapon( "m9k_ak47" ):GetPrimaryAmmoType() )
		ply:SelectWeapon( "m9k_ak47" )
		
		ply:Give( "m9k_sig_p229r" )
		ply:SetAmmo( 48, ply:GetWeapon( "m9k_sig_p229r" ):GetPrimaryAmmoType() )
	end
	
	if ply:Team() == 7 then
		ply:Give( "m9k_1897winchester" )
		ply:SetAmmo( 16, ply:GetWeapon( "m9k_1897winchester" ):GetPrimaryAmmoType() )
		ply:SelectWeapon( "m9k_1897winchester" )
		
		ply:Give( "m9k_sig_p229r" )
		ply:SetAmmo( 48, ply:GetWeapon( "m9k_sig_p229r" ):GetPrimaryAmmoType() )
	end
	
	if ply:Team() == 9 then
		ply:Give( "m9k_remington7615p" )
		ply:SetAmmo( 40, ply:GetWeapon( "m9k_remington7615p" ):GetPrimaryAmmoType() )
		ply:SelectWeapon( "m9k_remington7615p" )
		
		ply:Give( "m9k_sig_p229r" )
		ply:SetAmmo( 48, ply:GetWeapon( "m9k_sig_p229r" ):GetPrimaryAmmoType() )
	end
	
	if ply:Team() == 11 then
		ply:Give( "m9k_uzi" )
		ply:SetAmmo( 128, ply:GetWeapon( "m9k_uzi" ):GetPrimaryAmmoType() )
		ply:SelectWeapon( "m9k_uzi" )
		
		ply:Give( "m9k_rpg7" )
		ply:SetAmmo( 2, ply:GetWeapon( "m9k_rpg7" ):GetPrimaryAmmoType() )
		
		ply:Give( "m9k_sig_p229r" )
		ply:SetAmmo( 48, ply:GetWeapon( "m9k_sig_p229r" ):GetPrimaryAmmoType() )
	end
	
	if ply:Team() == 12 then
		ply:Give( "m9k_ied_detonator" )
		ply:SetAmmo( 0, ply:GetWeapon( "m9k_ied_detonator" ):GetPrimaryAmmoType() )
	end
end

function GM:PlayerDisconnected( ply )
	ply:SetPData( "playerLevel", ply:GetNWInt( "playerLevel" ) )
	ply:SetPData( "playerExp", ply:GetNWInt( "playerExp" ) )
	ply:SetPData( "playerMoney", ply:GetNWInt( "playerMoney" ) )
end

function GM:ShutDown()
	for k, v in pairs( player.GetAll() ) do
		v:SetPData( "playerLevel", v:GetNWInt( "playerLevel" ) )
		v:SetPData( "playerExp", v:GetNWInt( "playerExp" ) )
		v:SetPData( "playerMoney", v:GetNWInt( "playerMoney" ) )
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

function dm_team1( ply )
	if ( team.NumPlayers( 3 ) + team.NumPlayers( 4 ) + team.NumPlayers( 5 ) + team.NumPlayers( 8 ) + team.NumPlayers( 10 ) ) > ( team.NumPlayers( 2 ) + team.NumPlayers( 6 ) + team.NumPlayers( 7 ) + team.NumPlayers( 9 ) + team.NumPlayers( 11 ) + team.NumPlayers( 12 ) ) then
		ply:PrintMessage( HUD_PRINTTALK, "There are too many players on this team." )
	else
		ply:SetTeam( 3 )
		ply:StripWeapons()
		PrintMessage( HUD_PRINTTALK, ply:GetName() .. " has joined Counter Terrorists." )
		ply:Spawn()
	end
end
concommand.Add( "dm_team1", dm_team1 )

function dm_team1_class1( ply )
	ply:SetTeam( 4 )
	ply:StripWeapons()
	ply:Spawn()
end
concommand.Add( "dm_team1_class1", dm_team1_class1 )

function dm_team1_class2( ply )
	ply:SetTeam( 5 )
	ply:StripWeapons()
	ply:Spawn()
end
concommand.Add( "dm_team1_class2", dm_team1_class2 )

function dm_team1_class3( ply )
	ply:SetTeam( 8 )
	ply:StripWeapons()
	ply:Spawn()
end
concommand.Add( "dm_team1_class3", dm_team1_class3 )

function dm_team1_class4( ply )
	ply:SetTeam( 10 )
	ply:StripWeapons()
	ply:Spawn()
end
concommand.Add( "dm_team1_class4", dm_team1_class4 )

function dm_team2( ply )
	if ( team.NumPlayers( 2 ) + team.NumPlayers( 6 ) + team.NumPlayers( 7 ) + team.NumPlayers( 9 ) + team.NumPlayers( 11 ) + team.NumPlayers( 12 ) ) > ( team.NumPlayers( 3 ) + team.NumPlayers( 4 ) + team.NumPlayers( 5 ) + team.NumPlayers( 8 ) + team.NumPlayers( 10 ) ) then
		ply:PrintMessage( HUD_PRINTTALK, "There are too many players on this team." )
	else
		ply:SetTeam( 2 )
		ply:StripWeapons()
		PrintMessage( HUD_PRINTTALK, ply:GetName() .. " has joined Terrorists." )
		ply:Spawn()
	end
end
concommand.Add( "dm_team2", dm_team2 )

function dm_team2_class1( ply )
	ply:SetTeam( 6 )
	ply:StripWeapons()
	ply:Spawn()
end
concommand.Add( "dm_team2_class1", dm_team2_class1 )

function dm_team2_class2( ply )
	ply:SetTeam( 7 )
	ply:StripWeapons()
	ply:Spawn()
end
concommand.Add( "dm_team2_class2", dm_team2_class2 )

function dm_team2_class3( ply )
	ply:SetTeam( 9 )
	ply:StripWeapons()
	ply:Spawn()
end
concommand.Add( "dm_team2_class3", dm_team2_class3 )

function dm_team2_class4( ply )
	ply:SetTeam( 11 )
	ply:StripWeapons()
	ply:Spawn()
end
concommand.Add( "dm_team2_class4", dm_team2_class4 )

function dm_team2_class5( ply )
	ply:SetTeam( 12 )
	ply:StripWeapons()
	ply:Spawn()
end
concommand.Add( "dm_team2_class5", dm_team2_class5 )

function resetlevel( ply )
	ply:SetNWInt( "playerLevel", 1 )
	ply:SetNWInt( "playerExp", 0 )
	ply:SetNWInt( "playerMoney", 0 )
	ply:SetNWInt( "hasM4", 0 )
	ply:SetNWInt( "hasAK", 0 )
	ply:SetNWInt( "hasDE", 0 )
	ply:SetNWInt( "equipped", 0 )
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

