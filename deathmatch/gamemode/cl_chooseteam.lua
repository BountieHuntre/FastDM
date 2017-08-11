include( "shared.lua" )

surface.CreateFont( "Reg", {
	font = "Trebuchet24",
	extended = false,
	size = 24,
	weight = 550,
	antialias = true
} )

local Ready = nil
local visible = true

function set_team( ply )
	Ready = vgui.Create( "DFrame" )
	Ready:SetPos( ScrW() / 4, ScrH() / 4 )
	Ready:SetSize( ScrW() / 2, ScrH() / 2 )
	Ready:SetTitle( "" )
	Ready:SetVisible( true )
	Ready:SetDraggable( false )
	Ready:ShowCloseButton( false )
	Ready.Paint = function()
		draw.RoundedBox( 0, 0, 0, Ready:GetWide(), Ready:GetTall(), Color( 60, 60, 60, 255 ) )
	end
	Ready:MakePopup()
	
	ready1 = vgui.Create( "DButton", Ready )
	ready1:SetPos( 1, 1 )
	ready1:SetSize( Ready:GetWide() / 2 - 2, Ready:GetTall() - 2 )
	ready1:SetText( "Counter Terrorists" )
	ready1:SetFont( "Reg" )
	ready1:SetTextColor( Color( 0, 0, 0, 255 ) )
	ready1.Paint = function()
		draw.RoundedBox( 0, 0, 0, ready1:GetWide(), ready1:GetTall(), team.GetColor( 3 ) )
	end
	if ply:Team() == 3 or ply:Team() == 4 or ply:Team() == 5 or ply:Team() == 8 or ply:Team() == 10 then
		ready1.DoClick = function()
			Ready:Close()
			ply:PrintMessage( HUD_PRINTTALK, "You are already on the Counter Terrorist team." )
		end
	else
		ready1.DoClick = function()
			ply:ConCommand( "dm_team1" )
			Ready:Close()
			timer.Simple( 0.075, function() ply:ConCommand( "dm_class" ) end )
		end
	end
	
	ready2 = vgui.Create( "DButton", Ready )
	ready2:SetPos( Ready:GetWide() / 2, 1 )
	ready2:SetSize( Ready:GetWide() / 2 - 2, Ready:GetTall() - 2 )
	ready2:SetText( "Terrorists" )
	ready2:SetFont( "Reg" )
	ready2:SetTextColor( Color( 0, 0, 0, 255 ) )
	ready2.Paint = function()
		draw.RoundedBox( 0, 0, 0, ready2:GetWide(), ready2:GetTall(), team.GetColor( 2 ) )
	end
	if ply:Team() == 2 or ply:Team() == 6 or ply:Team() == 7 or ply:Team() == 9 or ply:Team() == 11 then
		ready2.DoClick = function()
			Ready:Close()
			ply:PrintMessage( HUD_PRINTTALK, "You are already on the Terrorist team." )
		end
	else
		ready2.DoClick = function()
			ply:ConCommand( "dm_team2" )
			Ready:Close()
			timer.Simple( 0.075, function() ply:ConCommand( "dm_class" ) end )
		end
	end
end
concommand.Add( "dm_start", set_team )

function set_class( ply )
	class = vgui.Create( "DFrame" )
	class:SetPos( ScrW() / 4, ScrH() / 4 )
	class:SetSize( ScrW() / 2, ScrH() / 2 )
	class:SetTitle( "" )
	class:SetVisible( true )
	class:SetDraggable( false )
	class:ShowCloseButton( false )
	class.Paint = function()
		draw.RoundedBox( 0, 0, 0, class:GetWide(), class:GetTall(), Color( 60, 60, 60, 255 ) )
	end
	class:MakePopup()
	if ply:Team() == 2 or ply:Team() == 6 or ply:Team() == 7 or ply:Team() == 9 or ply:Team() == 11 or ply:Team() == 12 then
		class1 = vgui.Create( "DButton", class )
		class1:SetPos( 1, 1 )
		class1:SetSize( class:GetWide() / 3 - 3, class:GetTall() / 2 - 3 )
		class1:SetText( "Assault" )
		class1:SetFont( "Reg" )
		class1:SetTextColor( Color( 0, 0, 0, 255 ) )
		class1.Paint = function()
			draw.RoundedBox( 0, 0, 0, class1:GetWide(), class1:GetTall(), team.GetColor( 2 ) )
		end
		if ply:Team() == 2 or ply:Team() == 7 or ply:Team() == 9 or ply:Team() == 11 or ply:Team() == 12 then
			class1.DoClick = function()
				ply:ConCommand( "dm_team2_class1" )
				class:Close()
			end
		elseif ply:Team() == 6 then
			class1.DoClick = function()
				class:Close()
				ply:PrintMessage( HUD_PRINTTALK, "You are the Assault class already." )
			end
		else
			class1.DoClick = function()
				class:Close()
				ply:PrintMessage( HUD_PRINTTALK, "You have not joined a team yet." )
			end
		end
		
		class2 = vgui.Create( "DButton", class )
		class2:SetPos( 1, class:GetTall() / 2 )
		class2:SetSize( class:GetWide() / 2 - 2, class:GetTall() / 2 - 1 )
		class2:SetText( "Medic" )
		class2:SetFont( "Reg" )
		class2:SetTextColor( Color( 0, 0, 0, 255 ) )
		class2.Paint = function()
			draw.RoundedBox( 0, 0, 0, class2:GetWide(), class2:GetTall(), team.GetColor( 2 ) )
		end
		if ply:Team() == 2 or ply:Team() == 6 or ply:Team() == 9 or ply:Team() == 11 or ply:Team() == 12 then
			class2.DoClick = function()
				ply:ConCommand( "dm_team2_class2" )
				class:Close()
			end
		elseif ply:Team() == 7 then
			class2.DoClick = function()
				class:Close()
				ply:PrintMessage( HUD_PRINTTALK, "You are the Medic class already." )
			end
		else
			class2.DoClick = function()
				class:Close()
				ply:PrintMessage( HUD_PRINTTALK, "You have not joined a team yet." )
			end
		end
		
		class3 = vgui.Create( "DButton", class )
		class3:SetPos( class:GetWide() / 3, 1 )
		class3:SetSize( class:GetWide() / 3 - 3, class:GetTall() / 2 - 3 )
		class3:SetText( "Sniper" )
		class3:SetFont( "Reg" )
		class3:SetTextColor( Color( 0, 0, 0, 255 ) )
		class3.Paint = function()
			draw.RoundedBox( 0, 0, 0, class3:GetWide(), class3:GetTall(), team.GetColor( 2 ) )
		end
		if ply:Team() == 2 or ply:Team() == 6 or ply:Team() == 7 or ply:Team() == 11 or ply:Team() == 12 then
			class3.DoClick = function()
				ply:ConCommand( "dm_team2_class3" )
				class:Close()
			end
		elseif ply:Team() == 9 then
			class3.DoClick = function()
				class:Close()
				ply:PrintMessage( HUD_PRINTTALK, "You are the Sniper class already." )
			end
		else
			class3.DoClick = function()
				class:Close()
				ply:PrintMessage( HUD_PRINTTALK, "You have not joined a team yet." )
			end
		end
		
		class4 = vgui.Create( "DButton", class )
		class4:SetPos( class:GetWide() / 2, class:GetTall() / 2 )
		class4:SetSize( class:GetWide() / 2 - 1, class:GetTall() / 2 - 1 )
		class4:SetText( "Specialist" )
		class4:SetFont( "Reg" )
		class4:SetTextColor( Color( 0, 0, 0, 255 ) )
		class4.Paint = function()
			draw.RoundedBox( 0, 0, 0, class4:GetWide(), class4:GetTall(), team.GetColor( 2 ) )
		end
		if ply:Team() == 2 or ply:Team() == 6 or ply:Team() == 7 or ply:Team() == 9 or ply:Team() == 12 then
			class4.DoClick = function()
				ply:ConCommand( "dm_team2_class4" )
				class:Close()
			end
		elseif ply:Team() == 11 then
			class4.DoClick = function()
				class:Close()
				ply:PrintMessage( HUD_PRINTTALK, "You are the Specialist class already." )
			end
		else
			class4.DoClick = function()
				class:Close()
				ply:PrintMessage( HUD_PRINTTALK, "You have not joined a team yet." )
			end
		end
		
		class5 = vgui.Create( "DButton", class )
		class5:SetPos( class:GetWide() / 3 + class:GetWide() / 3 - 1, 1 )
		class5:SetSize( class:GetWide() / 3, class:GetTall() / 2 - 3 )
		class5:SetText( "Suicide Bomber" )
		class5:SetFont( "Reg" )
		class5:SetTextColor( Color( 0, 0, 0, 255 ) )
		class5.Paint = function()
			draw.RoundedBox( 0, 0, 0, class5:GetWide(), class5:GetTall(), team.GetColor( 2 ) )
		end
		if ply:Team() == 2 or ply:Team() == 6 or ply:Team() == 7 or ply:Team() == 9 or ply:Team() == 11 then
			class5.DoClick = function()
				ply:ConCommand( "dm_team2_class5" )
				class:Close()
			end
		elseif ply:Team() == 12 then
			class5.DoClick = function()
				class:Close()
				ply:PrintMessage( HUD_PRINTTALK, "You are the Suicide Bomber class already." )
			end
		else
			class5.DoClick = function()
				class:Close()
				ply:PrintMessage( HUD_PRINTTALK, "You have not joined a team yet." )
			end
		end
	else
		class1 = vgui.Create( "DButton", class )
		class1:SetPos( 1, 1 )
		class1:SetSize( class:GetWide() / 2 - 3, class:GetTall() / 2 - 3 )
		class1:SetText( "Assault" )
		class1:SetFont( "Reg" )
		class1:SetTextColor( Color( 0, 0, 0, 255 ) )
		class1.Paint = function()
			draw.RoundedBox( 0, 0, 0, class1:GetWide(), class1:GetTall(), team.GetColor( 3 ) )
		end
		if ply:Team() == 3 or ply:Team() == 5 or ply:Team() == 8 or ply:Team() == 10 then
			class1.DoClick = function()
				ply:ConCommand( "dm_team1_class1" )
				class:Close()
			end
		elseif ply:Team() == 4 then
			class1.DoClick = function()
				class:Close()
				ply:PrintMessage( HUD_PRINTTALK, "You are the Assault class already." )
			end
		else
			class1.DoClick = function()
				class:Close()
				ply:PrintMessage( HUD_PRINTTALK, "You have not joined a team yet." )
			end
		end
		
		class2 = vgui.Create( "DButton", class )
		class2:SetPos( 1, class:GetTall() / 2 )
		class2:SetSize( class:GetWide() / 2 - 3, class:GetTall() / 2 - 1 )
		class2:SetText( "Medic" )
		class2:SetFont( "Reg" )
		class2:SetTextColor( Color( 0, 0, 0, 255 ) )
		class2.Paint = function()
			draw.RoundedBox( 0, 0, 0, class2:GetWide(), class2:GetTall(), team.GetColor( 3 ) )
		end
		if ply:Team() == 3 or ply:Team() == 4 or ply:Team() == 8 or ply:Team() == 10 then
			class2.DoClick = function()
				ply:ConCommand( "dm_team1_class2" )
				class:Close()
			end
		elseif ply:Team() == 5 or ply:Team() == 7 then
			class2.DoClick = function()
				class:Close()
				ply:PrintMessage( HUD_PRINTTALK, "You are the Marksman class already." )
			end
		else
			class2.DoClick = function()
				class:Close()
				ply:PrintMessage( HUD_PRINTTALK, "You have not joined a team yet." )
			end
		end
		
		class3 = vgui.Create( "DButton", class )
		class3:SetPos( class:GetWide() / 2, 1 )
		class3:SetSize( class:GetWide() / 2 - 1, class:GetTall() / 2 - 3 )
		class3:SetText( "Sniper" )
		class3:SetFont( "Reg" )
		class3:SetTextColor( Color( 0, 0, 0, 255 ) )
		class3.Paint = function()
			draw.RoundedBox( 0, 0, 0, class3:GetWide(), class3:GetTall(), team.GetColor( 3 ) )
		end
		if ply:Team() == 3 or ply:Team() == 4 or ply:Team() == 5 or ply:Team() == 10 then
			class3.DoClick = function()
				ply:ConCommand( "dm_team1_class3" )
				class:Close()
			end
		elseif ply:Team() == 8 or ply:Team() == 9 then
			class3.DoClick = function()
				class:Close()
				ply:PrintMessage( HUD_PRINTTALK, "You are the Sniper class already." )
			end
		else
			class3.DoClick = function()
				class:Close()
				ply:PrintMessage( HUD_PRINTTALK, "You have not joined a team yet." )
			end
		end
		
		class4 = vgui.Create( "Button", class )
		class4:SetPos( class:GetWide() / 2, class:GetTall() / 2 )
		class4:SetSize( class:GetWide() / 2 - 1, class:GetTall() / 2 - 1 )
		class4:SetText( "Specialist" )
		class4:SetFont( "Reg" )
		class4:SetTextColor( Color( 0, 0, 0, 255 ) )
		class4.Paint = function()
			draw.RoundedBox( 0, 0, 0, class4:GetWide(), class4:GetTall(), team.GetColor( 3 ) )
		end
		if ply:Team() == 3 or ply:Team() == 4 or ply:Team() == 5 or ply:Team() == 8 then
			class4.DoClick = function()
				ply:ConCommand( "dm_team1_class4" )
				class:Close()
			end
		elseif ply:Team() == 10 or ply:Team() == 11 then
			class4.DoClick = function()
				class:Close()
				ply:PrintMessage( HUD_PRINTTALK, "You are the Specialist class already." )
			end
		else
			class4.DoClick = function()
				class:Close()
				ply:PrintMessage( HUD_PRINTTALK, "You have not joined a team yet." )
			end
		end
	end
end
concommand.Add( "dm_class", set_class )