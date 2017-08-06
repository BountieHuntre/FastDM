surface.CreateFont( "BIG_T", {
	font = "Trebuchet24",
	extended = false,
	size = 60,
	weight = 550,
	antialias = true
} )
	
function HUD()
	local ply = LocalPlayer()
	
	if !ply:Alive() then
		return
	end
	
	draw.RoundedBox( 0, 5, ScrH() - 105, 250, 100, Color( 30, 30, 30, 190 ) )
	draw.RoundedBox( 0, 10, ScrH() - 100, 240 * ply:Health() / 100, 90, Color( 255, 0, 0, 255 ) )
	draw.SimpleText( ply:Health(), "BIG_T", 240, ScrH() - 87, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT )
	
	draw.RoundedBox( 0, ScrW() - 230, ScrH() - 105, 225, 100, Color( 30, 30, 30, 190 ) )
	
	if ( ply:GetActiveWeapon():IsValid() ) then
		local cWep = ply:GetActiveWeapon():GetClass()
		
		if ( ply:GetActiveWeapon():GetPrintName() != nil ) then
			draw.SimpleText( ply:GetActiveWeapon():GetPrintName(), "Trebuchet18", ScrW() - 220, ScrH() - 98, Color( 255, 255, 255, 255 ), 0, 0 )
		end
		
		if ( cWep != "m9k_machete" ) then
			if ( cWep == "weapon_medkit" ) then
				draw.SimpleText( ply:GetActiveWeapon():Clip1(), "BIG_T", ScrW() - 20, ScrH() - 80, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT )
			elseif ( ply:GetActiveWeapon():Clip1() != -1 ) then
				draw.SimpleText( ply:GetActiveWeapon():Clip1() .. " / " .. ply:GetAmmoCount( ply:GetActiveWeapon():GetPrimaryAmmoType()), "BIG_T", ScrW() - 20, ScrH() - 80, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT )
			else
				draw.SimpleText( ply:GetAmmoCount( ply:GetActiveWeapon():GetPrimaryAmmoType() ), "BIG_T", ScrW() - 20, ScrH() - 80, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT )
			end
		end
	end
	
	local etl = ( ply:GetNWInt( "playerLevel" ) * 100 ) * ( ply:GetNWInt( "playerLevel" ) * 1.2 )
	
	draw.RoundedBox( 0, 5, ScrH() - 170, 250, 65, Color( 30, 30, 30, 190 ) )
	draw.SimpleText( ply:GetNWInt( "playerLevel" ), "BIG_T", 245, ScrH() - 165, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT )
	draw.SimpleText( "EXP: " .. ply:GetNWInt( "playerExp" ) .. " / " .. etl, "Trebuchet18", 15, ScrH() - 155, Color( 255, 255, 255, 255 ) )
	draw.SimpleText( "$" .. ply:GetNWInt( "playerMoney" ), "Trebuchet18", 15, ScrH() - 130, Color( 255, 255, 255, 255 ) )
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

