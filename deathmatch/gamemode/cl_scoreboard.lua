include( "shared.lua" )

local scoreboard = nil
local pList = nil

function GM:ScoreboardShow()
	if !IsValid(scoreboard) then
		scoreboard = vgui.Create( "DFrame" )
		scoreboard:SetPos( ScrW() / 4, ScrH() / 4) 
		scoreboard:SetSize( ScrW() / 2, ScrH() / 2 )
		scoreboard:SetTitle( "" )
		scoreboard:SetDraggable( false )
		scoreboard:ShowCloseButton( false )
		scoreboard.Paint = function()
			draw.RoundedBox( 0, 0, 0, scoreboard:GetWide(), scoreboard:GetTall(), Color( 60, 60, 60, 190 ) )
		end
		
		local panel = vgui.Create( "DScrollPanel", scoreboard )
		panel:SetSize( scoreboard:GetWide(), scoreboard:GetTall() - 20 )
		panel:SetPos( 0, 0 )
		
		pList = vgui.Create( "DListLayout", panel )
		pList:SetSize( panel:GetWide(), panel:GetTall() )
		pList:SetPos( 0, 0 )
	end
	
	if IsValid(scoreboard) then
		pList:Clear()
		
		for k, v in pairs( player.GetAll() ) do
			local pPanel = vgui.Create( "DPanel", pList )
			pPanel:SetSize( pList:GetWide(), 50 )
			pPanel:SetPos( 0, 0 )
			pPanel.Paint = function()
				draw.RoundedBox( 0, 0, 0, pPanel:GetWide(), pPanel:GetTall(), team.GetColor( v:Team() ) )
				draw.RoundedBox( 0, 0, 49, pPanel:GetWide(), 1, Color( 255, 255, 255, 255 ) )
				
				draw.SimpleText( v:GetName(), "Trebuchet24", 20, 13, Color( 0, 0, 0 ) )
				draw.SimpleText( "Kills: " .. v:Frags(), "Trebuchet24", pList:GetWide() / 1.65, 13, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER )
				draw.SimpleText( "Deaths: " .. v:Deaths(), "Trebuchet24", pList:GetWide() / 1.28, 13, Color( 0, 0, 0 ), TEXT_ALIGN_CENTER )
				draw.SimpleText( "Ping: " .. v:Ping(), "Trebuchet24", pList:GetWide() - 20, 13, Color( 0, 0, 0 ), TEXT_ALIGN_RIGHT )
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
