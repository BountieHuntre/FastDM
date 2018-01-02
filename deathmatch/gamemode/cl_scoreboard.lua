include( "shared.lua" )

local scoreboard = nil
local pList = nil

function GM:ScoreboardShow()
	if !IsValid(scoreboard) then
		scoreboard = vgui.Create( "DFrame" )
		scoreboard:SetPos( ScrW() / 6, ScrH() / 6) 
		scoreboard:SetSize( ScrW() / 1.5, ScrH() / 1.5 )
		scoreboard:SetTitle( "" )
		scoreboard:SetDraggable( false )
		scoreboard:ShowCloseButton( false )
		scoreboard.Paint = function()
			draw.RoundedBox( 0, 0, 0, scoreboard:GetWide(), scoreboard:GetTall(), Color( 60, 60, 60, 190 ) )
		end
		
		t1 = vgui.Create( "DFrame", scoreboard )
		t1:SetPos( 0, 0 )
		t1:SetSize( scoreboard:GetWide(), scoreboard:GetTall() / 3 )
		t1:SetTitle( "" )
		t1:SetDraggable( false )
		t1:ShowCloseButton( false )
		t1.Paint = function()
			draw.RoundedBox( 0, 0, 0, t1:GetWide(), t1:GetTall(), Color( 51, 110, 235, 255 ) )
			draw.SimpleText( "Counter Terrorists", "BIG_T", t1:GetWide() / 99, t1:GetTall() / -25, Color( 0, 0, 0 ), TEXT_ALIGN_LEFT )
		end
		
		t1Panel = vgui.Create( "DScrollPanel", t1 )
		t1Panel:SetSize( t1:GetWide(), t1:GetTall() / 1.25 )
		t1Panel:SetPos( 0, t1:GetTall() / 5 )
		t1Panel.Paint = function()
			draw.RoundedBox( 0, 0, 0, t1Panel:GetWide(), t1Panel:GetTall(), Color( 71, 130, 255, 255 ) )
		end
		
		t1_pList = vgui.Create( "DListLayout", t1Panel )
		t1_pList:SetSize( t1Panel:GetWide(), t1Panel:GetTall() )
		t1_pList:SetPos( 0, 0 )
		
		t2 = vgui.Create( "DFrame", scoreboard )
		t2:SetPos( 0, t1:GetTall() )
		t2:SetSize( scoreboard:GetWide(), scoreboard:GetTall() / 3 )
		t2:SetTitle( "" )
		t2:SetDraggable( false )
		t2:ShowCloseButton( false )
		t2.Paint = function()
			draw.RoundedBox( 0, t2:GetPos(), t2:GetPos(), t2:GetWide(), t2:GetTall(), Color( 220, 145, 0, 255 ) )
			draw.SimpleText( "Terrorists", "BIG_T", t2:GetWide() / 99, t2:GetTall() / -25, Color( 0, 0, 0 ), TEXT_ALIGN_LEFT )
		end
		
		t2Panel = vgui.Create( "DScrollPanel", t2 )
		t2Panel:SetSize( t2:GetWide(), t2:GetTall() / 1.25 )
		t2Panel:SetPos( 0, t2:GetTall() / 5 )
		t2Panel.Paint = function()
			draw.RoundedBox( 0, 0, 0, t2Panel:GetWide(), t2Panel:GetTall(), Color( 250, 175, 0, 255 ) )
		end
		
		t2_pList = vgui.Create( "DListLayout", t2Panel )
		t2_pList:SetSize( t2Panel:GetWide(), t2Panel:GetTall() )
		t2_pList:SetPos( 0, 0 )
		
		t3 = vgui.Create( "DFrame", scoreboard )
		t3:SetPos( 0, t2:GetTall() * 2 )
		t3:SetSize( scoreboard:GetWide(), scoreboard:GetTall() / 3 )
		t3:SetTitle( "" )
		t3:SetDraggable( false )
		t3:ShowCloseButton( false )
		t3.Paint = function()
			draw.RoundedBox( 0, t3:GetPos(), t3:GetPos(), t3:GetWide(), t3:GetTall(), Color( 95, 95, 95, 255 ) )
			draw.SimpleText( "Spectators", "BIG_T", t3:GetWide() / 99, t3:GetTall() / -25, Color( 255, 255, 255 ), TEXT_ALIGN_LEFT )
		end
		
		t3Panel = vgui.Create( "DScrollPanel", t3 )
		t3Panel:SetSize( t3:GetWide(), t3:GetTall() / 1.25 )
		t3Panel:SetPos( 0, t3:GetTall() / 5 )
		t3Panel.Paint = function()
			draw.RoundedBox( 0, 0, 0, t3Panel:GetWide(), t3Panel:GetTall(), Color( 125, 125, 125, 255 ) )
		end
		
		t3_pList = vgui.Create( "DListLayout", t3Panel )
		t3_pList:SetSize( t3Panel:GetWide(), t3Panel:GetTall() )
		t3_pList:SetPos( 0, 0 )
	end
	
	if IsValid(scoreboard) then
		t1_pList:Clear()
		t2_pList:Clear()
		t3_pList:Clear()
		
		for k, v in pairs( player.GetAll() ) do
			if ( v:Team() > 3 and v:Team() < 9 ) then
				local t1_pPanel = vgui.Create( "DPanel", t1_pList )
				t1_pPanel:SetSize( t1_pList:GetWide(), 50 )
				t1_pPanel:SetPos( 0, 0 )
				t1_pPanel.Paint = function()
					draw.RoundedBox( 0, 0, 0, t1_pPanel:GetWide(), t1_pPanel:GetTall(), team.GetColor( v:Team() ) )
					draw.RoundedBox( 0, 0, 49, t1_pPanel:GetWide(), 1, Color( 255, 255, 255, 255 ) )
					
					draw.SimpleText( v:GetName(), "Reg", 20, 13, Color( 0, 0, 0 ) )
					draw.SimpleText( "Lvl "..v:GetNWInt( "playerLevel" ), "Reg", t1_pList:GetWide() / 2.75, 13, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER )
					draw.SimpleText( "Kills: " .. v:Frags(), "Reg", t1_pList:GetWide() / 1.65, 13, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER )
					draw.SimpleText( "Deaths: " .. v:Deaths(), "Reg", t1_pList:GetWide() / 1.28, 13, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER )
					draw.SimpleText( "Ping: " .. v:Ping(), "Reg", t1_pList:GetWide() - 20, 13, Color( 0, 0, 0 ), TEXT_ALIGN_RIGHT )
				end
			end
			if ( v:Team() > 20 and v:Team() < 26 ) then
				local t2_pPanel = vgui.Create( "DPanel", t2_pList )
				t2_pPanel:SetSize( t2_pList:GetWide(), 50 )
				t2_pPanel:SetPos( 0, 0 )
				t2_pPanel.Paint = function()
					draw.RoundedBox( 0, 0, 0, t2_pPanel:GetWide(), t2_pPanel:GetTall(), team.GetColor( v:Team() ) )
					draw.RoundedBox( 0, 0, 49, t2_pPanel:GetWide(), 1, Color( 255, 255, 255, 255 ) )
					
					draw.SimpleText( v:GetName(), "Reg", 20, 13, Color( 0, 0, 0 ) )
					draw.SimpleText( "Lvl "..v:GetNWInt( "playerLevel" ), "Reg", t1_pList:GetWide() / 2.75, 13, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER )
					draw.SimpleText( "Kills: " .. v:Frags(), "Reg", t1_pList:GetWide() / 1.65, 13, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER )
					draw.SimpleText( "Deaths: " .. v:Deaths(), "Reg", t1_pList:GetWide() / 1.28, 13, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER )
					draw.SimpleText( "Ping: " .. v:Ping(), "Reg", t1_pList:GetWide() - 20, 13, Color( 0, 0, 0 ), TEXT_ALIGN_RIGHT )
				end
			end
			if ( v:Team() == TEAM_SPECTATOR or v:Team() == TEAM_UNASSIGNED or v:Team() == 1 or v:Team() == 2 or v:Team() == 3 ) then
				local t3_pPanel = vgui.Create( "DPanel", t3_pList )
				t3_pPanel:SetSize( t3_pList:GetWide(), 50 )
				t3_pPanel:SetPos( 0, 0 )
				t3_pPanel.Paint = function()
					draw.RoundedBox( 0, 0, 0, t3_pPanel:GetWide(), t3_pPanel:GetTall(), team.GetColor( 1 ) )
					draw.RoundedBox( 0, 0, 49, t3_pPanel:GetWide(), 1, Color( 255, 255, 255, 255 ) )
					
					draw.SimpleText( v:GetName(), "Reg", 20, 13, Color( 255, 255, 255 ) )
					draw.SimpleText( "Lvl "..v:GetNWInt( "playerLevel" ), "Reg", t1_pList:GetWide() / 2.75, 13, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER )
					draw.SimpleText( "Kills: " .. v:Frags(), "Reg", t1_pList:GetWide() / 1.65, 13, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER )
					draw.SimpleText( "Deaths: " .. v:Deaths(), "Reg", t1_pList:GetWide() / 1.28, 13, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER )
					draw.SimpleText( "Ping: " .. v:Ping(), "Reg", t1_pList:GetWide() - 20, 13, Color( 255, 255, 255 ), TEXT_ALIGN_RIGHT )
				end
			end
		end
	
		scoreboard:Show()
		scoreboard:MakePopup()
		scoreboard:SetKeyboardInputEnabled( false )
	end
end

function GM:ScoreboardHide()
	if IsValid(scoreboard) then
		scoreboard:Hide()
	end
end
