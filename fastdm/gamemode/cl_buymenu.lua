include( "shared.lua" )
include( "weps.lua" )
include( "attachments.lua" )

local baseFrame = nil

local categories = {
	"Weapons",
	"Attachments"
}

local button = {}
local wTile = {}
local wPrice = {}
local aTile = {}
local aPrice = {}
local equip = {}
local material = {}

function buymenu( ply )
	local ply = LocalPlayer()
	
	baseFrame = vgui.Create( "DFrame" )
	baseFrame:SetPos( ScrW() / 4, ScrH() / 4 )
	baseFrame:SetSize( ScrW() / 2, ScrH() / 2 )
	baseFrame:SetTitle( "Shop" )
	baseFrame:SetVisible( true )
	baseFrame:SetDraggable( false )
	baseFrame:ShowCloseButton( true )
	baseFrame.Paint = function()
		draw.RoundedBox( 0, 0, 0, baseFrame:GetWide(), baseFrame:GetTall(), Color( 60, 60, 60, 255 ) )
	end
	baseFrame:MakePopup()
		
	categ = vgui.Create( "DFrame", baseFrame )
	categ:SetPos( baseFrame:GetWide() / 50, baseFrame:GetTall() / 13 )
	categ:SetSize( baseFrame:GetWide() / 5, baseFrame:GetTall() / 1.1175 )
	categ:SetTitle( "" )
	categ:SetVisible( true )
	categ:SetDraggable( false )
	categ:ShowCloseButton( false )
	categ.Paint = function()
		draw.RoundedBox( 0, 0, 0, categ:GetWide(), categ:GetTall(), Color( 150, 150, 150, 255 ) )
	end
	
	clist = vgui.Create( "DListLayout", categ )
	clist:SetPos( 0, 0 )
	clist:SetSize( categ:GetWide(), categ:GetTall() )
	
	for k, v in pairs( categories ) do
		button[k] = vgui.Create( "DButton", clist )
		button[k]:SetPos( 0, 0 )
		button[k]:SetSize( clist:GetWide(), clist:GetTall() / 10 )
		button[k]:SetText( categories[k] )
		button[k]:SetFont( "Reg" )
		button[k].Paint = function()
			if button[k]:IsDown() then
				draw.RoundedBox( 0, button[k]:GetPos( 1 ), button[k]:GetPos( 2 ), button[k]:GetWide(), button[k]:GetTall(), Color( 200, 200, 200, 255 ) )
				draw.RoundedBox( 0, button[k]:GetPos( 1 ), button[k]:GetTall() - 1, button[k]:GetWide(), 1, Color( 60, 60, 60, 255 ) )
			else
				draw.RoundedBox( 0, button[k]:GetPos( 1 ), button[k]:GetPos( 2 ), button[k]:GetWide(), button[k]:GetTall(), Color( 255, 255, 255, 255 )  )
				draw.RoundedBox( 0, button[k]:GetPos( 1 ), button[k]:GetTall() - 1, button[k]:GetWide(), 1, Color( 60, 60, 60, 255 ) )
			end
		end
		if k == 1 then
			button[k].DoClick = function()
				if aframe:IsVisible() then
					aframe:SetVisible( false )
				end
				if !wframe:IsVisible() then
					wframe:SetVisible( true )
				else
					wframe:SetVisible( false )
				end
			end
		end
		if k == 2 then
			button[k].DoClick = function()
				if wframe:IsVisible() then
					wframe:SetVisible( false )
				end
				if !aframe:IsVisible() then
					aframe:SetVisible( true )
				else
					aframe:SetVisible( false )
				end
			end
		end
	end
	
	iframe = vgui.Create( "DFrame", baseFrame )
	iframe:SetPos( baseFrame:GetWide() / 4.15, baseFrame:GetTall() / 13 )
	iframe:SetSize( baseFrame:GetWide() / 1.35, baseFrame:GetTall() / 1.1175 )
	iframe:SetTitle( "" )
	iframe:SetVisible( true )
	iframe:SetDraggable( false )
	iframe:ShowCloseButton( false )
	iframe.Paint = function()
		draw.RoundedBox( 0, 0, 0, iframe:GetWide(), iframe:GetTall(), Color( 150, 150, 150, 255 ) )
	end
	
	scroller = vgui.Create( "DScrollPanel", iframe )
	scroller:SetPos( 0, 0 )
	scroller:SetSize( iframe:GetWide(), iframe:GetTall() )
	
	wframe = vgui.Create( "DListLayout", scroller )
	wframe:SetPos( 0, 0 )
	wframe:SetSize( scroller:GetWide(), scroller:GetTall() )
	wframe:SetVisible( false )
	
	for k, v in pairs( weps ) do
		wTile[k] = vgui.Create( "DFrame", wframe )
		wTile[k]:SetPos( 0, 0 )
		wTile[k]:SetSize( wframe:GetWide(), wframe:GetTall() / 10 )
		wTile[k]:SetTitle( "" )
		wTile[k]:SetVisible( true )
		wTile[k]:SetDraggable( false )
		wTile[k]:ShowCloseButton( false )
		wTile[k].Paint = function()
			draw.RoundedBox( 0, 0, 0, wTile[k]:GetWide(), wTile[k]:GetTall(), Color( 255, 255, 255, 255 ) )
			draw.RoundedBox( 0, 0, wTile[k]:GetTall() - 1, wTile[k]:GetWide(), 1, Color( 60, 60, 60, 255 ) )
			draw.SimpleText( weps[k].name, "Reg", wTile[k]:GetWide() / 20, wTile[k]:GetTall() / 4, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT )
		end
		
		wPrice[k] = vgui.Create( "DButton", wTile[k] )
		wPrice[k]:SetPos( wTile[k]:GetWide() / 1.2, 0 )
		wPrice[k]:SetSize( wTile[k]:GetWide() / 5.95, wTile[k]:GetTall() )
		wPrice[k]:SetText( "" )
		wPrice[k]:SetFont( "Reg" )
		wPrice[k].Paint = function()
			if ( ply:GetNWBool( weps[k].nameS ) == false or ply:GetPData( weps[k].nameS ) == false ) then
				draw.RoundedBox( 0, 0, 0, wTile[k]:GetWide() / 5.95, wTile[k]:GetTall() - 1, Color( 0, 190, 0, 255 ) )
				draw.SimpleText( "$"..weps[k].price, "Reg", wPrice[k]:GetWide() / 2, wTile[k]:GetTall() / 4, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER )
			else
				draw.RoundedBox( 0, 0, 0, wTile[k]:GetWide() / 5.95, wTile[k]:GetTall() - 1, Color( 0, 0, 190, 255 ) )
				draw.SimpleText( "Equip", "Reg", wPrice[k]:GetWide() / 2, wTile[k]:GetTall() / 4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
			end
		end
		wPrice[k].DoClick = function()
			ply:ConCommand( "buy"..weps[k].nameS )
		end
	end
	
	aframe = vgui.Create( "DListLayout", scroller )
	aframe:SetPos( 0, 0 )
	aframe:SetSize( scroller:GetWide(), scroller:GetTall() )
	aframe:SetVisible( false )
	
	for k, v in pairs( att ) do
		aTile[k] = vgui.Create( "DFrame", aframe )
		aTile[k]:SetPos( 0, 0 )
		aTile[k]:SetSize( aframe:GetWide(), aframe:GetTall() / 10 )
		aTile[k]:SetTitle( "" )
		aTile[k]:SetVisible( true )
		aTile[k]:SetDraggable( false )
		aTile[k]:ShowCloseButton( false )
		aTile[k].Paint = function()
			draw.RoundedBox( 0, 0, 0, aTile[k]:GetWide(), aTile[k]:GetTall(), Color( 255, 255, 255, 255 ) )
			draw.RoundedBox( 0, 0, aTile[k]:GetTall() - 1, aTile[k]:GetWide(), 1, Color( 60, 60, 60, 255 ) )
			draw.SimpleText( att[k].name, "Reg", aTile[k]:GetWide() / 20, aTile[k]:GetTall() / 4, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT )
		end
		
		aPrice[k] = vgui.Create( "DButton", aTile[k] )
		aPrice[k]:SetPos( aTile[k]:GetWide() / 1.2, 0 )
		aPrice[k]:SetSize( aTile[k]:GetWide() / 5.95, aTile[k]:GetTall() )
		aPrice[k]:SetText( "" )
		aPrice[k]:SetFont( "Reg" )
		aPrice[k].Paint = function()
			if ply:GetNWBool( att[k].nameS ) == false or ply:GetPData( att[k].nameS ) == false or ply:GetNWBool( att[k].nameS ) == nil then
				draw.RoundedBox( 0, 0, 0, aTile[k]:GetWide() / 5.95, aTile[k]:GetTall() - 1, Color( 0, 190, 0, 255 ) )
				draw.SimpleText( "$"..att[k].price, "Reg", aPrice[k]:GetWide() / 2, aTile[k]:GetTall() / 4, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER )
			else
				draw.RoundedBox( 0, 0, 0, aTile[k]:GetWide() / 5.95, aTile[k]:GetTall() - 1, Color( 0, 0, 190, 255 ) )
				draw.SimpleText( "Equip", "Reg", aPrice[k]:GetWide() / 2, aTile[k]:GetTall() / 4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
			end
		end
		aPrice[k].DoClick = function()
			ply:ConCommand( "buy"..att[k].nameS )
		end
	end
end
concommand.Add( "buymenu", buymenu )