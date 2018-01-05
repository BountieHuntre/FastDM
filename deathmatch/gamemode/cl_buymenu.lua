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
		price = 7000,
		equip = "m9k_nitro",
		material = ""
	},
	sticky = {
		name = "Sticky Grenade",
		nameS = "Sticky",
		price = 1000,
		equip = "m9k_sticky_grenade",
		material = ""
	},
	nerve = {
		name = "Nerve Gas",
		nameS = "Nerve",
		price = 500000,
		equip = "m9k_nerve_gas",
		material = ""
	},
	sword = {
		name = "Damascus Sword",
		nameS = "Sword",
		price = 5000,
		equip = "m9k_damascus",
		material = ""
	},
	machete = {
		name = "Machete",
		nameS = "Machete",
		price = 0,
		equip = "m9k_machete",
		material = ""
	}
}

/*
test = {
	test1 = {
		name = "test1",
		nameS = "test1",
		price = 0,
		equip = "",
		material = "",
	},
	test2 = {
		name = "test2",
		nameS = "test2",
		price = 10,
		equip = "",
		material = ""
	}
}
*/

local categories = {
	"Weapons"//,
	//"test"
}

local button = {}
local wTile = {}
local wPrice = {}
//local tTile = {}
//local tPrice = {}
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
				/*
				if tframe:IsVisible() then
					tframe:SetVisible( false )
				end
				*/
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
				/*
				if !tframe:IsVisible() then
					tframe:SetVisible( true )
				else
					tframe:SetVisible( false )
				end
				*/
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
			draw.DrawText( weps[k].name, "Reg", wTile[k]:GetWide() / 20, wTile[k]:GetTall() / 4, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT )
		end
		
		wPrice[k] = vgui.Create( "DButton", wTile[k] )
		wPrice[k]:SetPos( wTile[k]:GetWide() / 1.2, 0 )
		wPrice[k]:SetSize( wTile[k]:GetWide() / 5.95, wTile[k]:GetTall() )
		wPrice[k]:SetText( "" )
		wPrice[k]:SetFont( "Reg" )
		wPrice[k].Paint = function()
			if ( ply:GetNWBool( weps[k].nameS ) == false or ply:GetPData( weps[k].nameS ) == false ) then
				draw.RoundedBox( 0, 0, 0, wTile[k]:GetWide() / 5.95, wTile[k]:GetTall() - 1, Color( 0, 190, 0, 255 ) )
				draw.DrawText( "$"..weps[k].price, "Reg", wPrice[k]:GetWide() / 2, wTile[k]:GetTall() / 4, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER )
			else
				draw.RoundedBox( 0, 0, 0, wTile[k]:GetWide() / 5.95, wTile[k]:GetTall() - 1, Color( 0, 0, 190, 255 ) )
				draw.DrawText( "Equip", "Reg", wPrice[k]:GetWide() / 2, wTile[k]:GetTall() / 4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
			end
		end
		wPrice[k].DoClick = function(  )
			ply:ConCommand( "buy"..weps[k].nameS )
		end
	end
	
	/*
	tframe = vgui.Create( "DListLayout", scroller )
	tframe:SetPos( 0, 0 )
	tframe:SetSize( scroller:GetWide(), scroller:GetTall() )
	tframe:SetVisible( false )
	
	for k, v in pairs( test ) do
		tTile[k] = vgui.Create( "DFrame", tframe )
		tTile[k]:SetPos( 0, 0 )
		tTile[k]:SetSize( tframe:GetWide(), tframe:GetTall() / 10 )
		tTile[k]:SetTitle( "" )
		tTile[k]:SetVisible( true )
		tTile[k]:SetDraggable( false )
		tTile[k]:ShowCloseButton( false )
		tTile[k].Paint = function()
			draw.RoundedBox( 0, 0, 0, tTile[k]:GetWide(), tTile[k]:GetTall(), Color( 255, 255, 255, 255 ) )
			draw.RoundedBox( 0, 0, tTile[k]:GetTall() - 1, tTile[k]:GetWide(), 1, Color( 60, 60, 60, 255 ) )
			draw.DrawText( test[k].name, "Reg", tTile[k]:GetWide() / 20, tTile[k]:GetTall() / 4, Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT )
		end
		
		tPrice[k] = vgui.Create( "DButton", tTile[k] )
		tPrice[k]:SetPos( tTile[k]:GetWide() / 1.2, 0 )
		tPrice[k]:SetSize( tTile[k]:GetWide() / 5.95, tTile[k]:GetTall() )
		tPrice[k]:SetText( "" )
		tPrice[k]:SetFont( "Reg" )
		tPrice[k].Paint = function()
			if ( ply:GetNWBool( test[k].nameS ) == false or ply:GetPData( test[k].nameS ) == false ) then
				draw.RoundedBox( 0, 0, 0, tTile[k]:GetWide() / 5.95, tTile[k]:GetTall() - 1, Color( 0, 190, 0, 255 ) )
				draw.DrawText( "$"..test[k].price, "Reg", tPrice[k]:GetWide() / 2, tTile[k]:GetTall() / 4, Color( 0, 0, 0, 255 ), TEXT_ALIGN_CENTER )
			else
				draw.RoundedBox( 0, 0, 0, tTile[k]:GetWide() / 5.95, tTile[k]:GetTall() - 1, Color( 0, 0, 190, 255 ) )
				draw.DrawText( "Equip", "Reg", tPrice[k]:GetWide() / 2, tTile[k]:GetTall() / 4, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
			end
		end
	end
	*/
end
concommand.Add( "buymenu", buymenu )
