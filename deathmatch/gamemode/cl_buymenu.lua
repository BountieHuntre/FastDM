include( "shared.lua" )

local baseFrame = nil

weps = {
	c4 = {
		name = "C4",
		nameS = "C4",
		price = 10000,
		equip = "m9k_suicide_bomb",
		material = ""
	},
	nitro = {
		name = "Nitro Glycerine",
		nameS = "Nitro",
		price = 10000,
		equip = "m9k_nitro",
		material = ""
	}
}

local categories = {
	"Weapons"
}

local button = {}
local tile = {}
local price = {}
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
		tile[k] = vgui.Create( "DFrame", wframe )
		tile[k]:SetPos( 0, 0 )
		tile[k]:SetSize( wframe:GetWide(), wframe:GetTall() / 10 )
		tile[k]:SetTitle( "" )
		tile[k]:SetVisible( true )
		tile[k]:SetDraggable( false )
		tile[k]:ShowCloseButton( false )
		tile[k].Paint = function()
			draw.RoundedBox( 0, 0, 0, tile[k]:GetWide(), tile[k]:GetTall(), Color( 255, 255, 255, 255 ) )
			draw.RoundedBox( 0, 0, tile[k]:GetTall() - 1, tile[k]:GetWide(), 1, Color( 60, 60, 60, 255 ) )
			draw.DrawText( weps[k].name, "Reg", tile[k]:GetWide() / 20, tile[k]:GetTall() / 4, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT )
		end
		
		price[k] = vgui.Create( "DButton", tile[k] )
		price[k]:SetPos( tile[k]:GetWide() / 1.2, 0 )
		price[k]:SetSize( tile[k]:GetWide() / 5.95, tile[k]:GetTall() )
		price[k]:SetText( "" )
		price[k]:SetFont( "Reg" )
		price[k].Paint = function()
			if ( ply:GetNWBool( weps[k].nameS ) == true ) then
				draw.RoundedBox( 0, 0, 0, tile[k]:GetWide() / 5.95, tile[k]:GetTall() - 1, Color( 0, 0, 190, 255 ) )
				draw.DrawText( "Equip", "Reg", price[k]:GetWide() / 2, tile[k]:GetTall() / 4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
			else
				draw.RoundedBox( 0, 0, 0, tile[k]:GetWide() / 5.95, tile[k]:GetTall() - 1, Color( 0, 190, 0, 255 ) )
				draw.DrawText( "$"..weps[k].price, "Reg", price[k]:GetWide() / 2, tile[k]:GetTall() / 4, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER )
			end
		end
		price[k].DoClick = function(  )
			ply:ConCommand( "buy"..weps[k].nameS )
		end
	end
end
concommand.Add( "buymenu", buymenu )
