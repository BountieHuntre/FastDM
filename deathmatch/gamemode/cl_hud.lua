include( "shared.lua" )
	
function HUD()
	local ply = LocalPlayer()
	
	local maxLevel = 20
	
	if !ply:Alive() then
		return
	end
	
	if ply:Team() == 1 then
		draw.SimpleText( "Press F1 to select your team!", "BIG_T", ScrW() / 2, ScrH() / 8, Color( 255, 50, 225, 255 ), TEXT_ALIGN_CENTER )
	end
	
	if ply:Team() == 2 or ply:Team() == 3 then
		draw.SimpleText( "Press F2 to select your class!", "BIG_T", ScrW() / 2, ScrH() / 8, Color( 255, 50, 225, 255 ), TEXT_ALIGN_CENTER )
	end
	
	//killcount box
	if ply:Team() == TEAM_SPECTATOR or ply:Team() == TEAM_UNASSIGNED or ply:Team() == 1 or ply:Team() == 2 or ply:Team() == 3 then
		return
	elseif ply:Team() > 20 and ply:Team() < 26 then
		draw.RoundedBox( 0, ScrW() - 300, 0, 300, 100, Color( 255, 175, 0, 150 ) )
	else
		draw.RoundedBox( 0, ScrW() - 300, 0, 300, 100, Color( 21, 80, 205, 150 ) )
	end
	draw.SimpleText( "Kills:", "Trebuchet18", ScrW() - 290, 5, Color( 255, 255, 255, 255 ) )
	draw.SimpleText( ply:GetNWInt( "playerKills" ), "BIG_T", ScrW() - 10, 35, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT )
	
	//stats box
	if ply:Team() > 20 and ply:Team() < 26 then
		draw.RoundedBox( 0, 5, ScrH() - 105, 250, 100, Color( 255, 175, 0, 150 ) )
	else
		draw.RoundedBox( 0, 5, ScrH() - 105, 250, 100, Color( 21, 80, 205, 150 ) )
	end
	
	//health box
	draw.RoundedBox( 0, 10, ScrH() - 100, 240 * ply:Health() / LocalPlayer():GetMaxHealth(), 90, Color( 255, 0, 0, 255 ) )
	draw.SimpleText( ply:Health(), "BIG_T", 240, ScrH() - 87, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT )
	
	//stamina box
	if ply:Team() > 20 and ply:Team() < 26 then
		draw.RoundedBox( 0, 5, ScrH() - 5, 250, 5, Color( 255, 175, 0, 150 ) )
	else
		draw.RoundedBox( 0, 5, ScrH() - 5, 250, 5, Color( 21, 80, 205, 150 ) )
	end
	draw.RoundedBox( 0, 10, ScrH() - 4.5, 240 * ply:GetNWInt( "Stamina" ) / 100, 2, Color( 0, 255, 0, 255 ) )
	
	//weapon box
	if ply:Team() == 1 then
		draw.RoundedBox( 0, ScrW() - 230, ScrH() - 105, 225, 100, Color( 30, 30, 30, 190 ) )
	elseif ply:Team() == 2 or ply:Team() == 21 or ply:Team() == 22 or ply:Team() == 23 or ply:Team() == 24 or ply:Team() == 25 then
		draw.RoundedBox( 0, ScrW() - 230, ScrH() - 105, 225, 100, Color( 255, 175, 0, 150 ) )
	else
		draw.RoundedBox( 0, ScrW() - 230, ScrH() - 105, 225, 100, Color( 21, 80, 205, 150 ) )
	end
	
	if ( ply:GetActiveWeapon():IsValid() ) then
		local cWep = ply:GetActiveWeapon():GetClass()
		
		if ( ply:GetActiveWeapon():GetPrintName() != nil ) then
			draw.SimpleText( ply:GetActiveWeapon():GetPrintName(), "Trebuchet18", ScrW() - 220, ScrH() - 98, Color( 255, 255, 255, 255 ), 0, 0 )
		end
		
		if ( cWep != "m9k_machete" ) then
			if ( cWep != "m9k_damascus" ) then
				if ( cWep == "weapon_medkit" ) then
					draw.SimpleText( ply:GetActiveWeapon():Clip1(), "BIG_T", ScrW() - 20, ScrH() - 80, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT )
				elseif ( ply:GetActiveWeapon():Clip1() != -1 ) then
					draw.SimpleText( ply:GetActiveWeapon():Clip1() .. " / " .. ply:GetAmmoCount( ply:GetActiveWeapon():GetPrimaryAmmoType()), "BIG_T", ScrW() - 20, ScrH() - 80, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT )
				else
					draw.SimpleText( ply:GetAmmoCount( ply:GetActiveWeapon():GetPrimaryAmmoType() ), "BIG_T", ScrW() - 20, ScrH() - 80, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT )
				end
			end
		end
	end
	
	local etl = ( ply:GetNWInt( "playerLevel" ) * 100 ) * ( ply:GetNWInt( "playerLevel" ) * 1.2 )
	
	//also stats box
	if ply:Team() == 1 then
		draw.RoundedBox( 0, 5, ScrH() - 170, 250, 65, Color( 30, 30, 30, 190 ) )
	elseif ply:Team() == 2 or ply:Team() == 21 or ply:Team() == 22 or ply:Team() == 23 or ply:Team() == 24 or ply:Team() == 25 then
		draw.RoundedBox( 0, 5, ScrH() - 170, 250, 65, Color( 255, 175, 0, 150 ) )
	else
		draw.RoundedBox( 0, 5, ScrH() - 170, 250, 65, Color( 21, 80, 205, 150 ) )
	end
	draw.SimpleText( ply:GetNWInt( "playerLevel" ), "BIG_T", 245, ScrH() - 165, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT )
	if tonumber( ply:GetNWInt( "playerLevel" ) ) < maxLevel then
		draw.SimpleText( "EXP: " .. ply:GetNWInt( "playerExp" ) .. " / " .. etl, "Trebuchet18", 15, ScrH() - 155, Color( 255, 255, 255, 255 ) )
	end
	draw.SimpleText( team.GetName( ply:Team() ), "Trebuchet18", 15, ScrH() - 130, Color( 255, 255, 255, 255 ) )
	
	//money
	draw.SimpleText( "$"..ply:GetNWInt( "playerMoney" ), "Trebuchet18", ScrW() - 10, 5, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT )
end
hook.Add( "HUDPaint", "PlayerHUD", HUD )

function HideHud( name )
	for k, v in pairs( { "CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo" } ) do
		 if name == v then
			return false
		 end
	end
end
hook.Add( "HUDShouldDraw", "HideDefaultHUD", HideHud )

