CLPLUGIN.Name = "Health/Ammo Display"
CLPLUGIN.Author = "F-Nox/Big Bang"

function CLPLUGIN.Init()
	
end

local plydamaged = false
local displaydamage = true
local alpha = 150
local pos, ang
local ent
local perc
local ammotext 
local textsizex, textsizey
local label
local menuopened
local trace
local tracedata = {}

hook.Add( "PostDrawOpaqueRenderables", "TiramisuHealthAmmoDisplay", function( )

	if ValidEntity( LocalPlayer():GetEyeTrace().Entity ) and CAKE.IsDoor(LocalPlayer():GetEyeTrace().Entity) then
		--Not yet lololol this is for door titles

	end

	if CAKE.Thirdperson:GetBool() and LocalPlayer():Alive() then
		if CAKE.MenuOpen then
			plydamaged = true
			menuopened = true
		elseif !CAKE.MenuOpen and menuopened then
			plydamaged = false
			displaydamage = false
			menuopened = false
		end
		if plydamaged and !displaydamage then
			displaydamage = true
		elseif plydamaged and displaydamage then
			alpha = 150
			pos, ang = LocalPlayer():GetBonePosition(LocalPlayer():LookupBone("ValveBiped.Bip01_Head1"))
		    ang:RotateAroundAxis( ang:Up(), 90 )
		    ang:RotateAroundAxis( ang:Forward() , -180 )
		    ang:RotateAroundAxis( ang:Right() , -90 )
		    cam.Start3D2D( pos - ( ang:Right() * 18 ), ang , 0.25 )
		        draw.RoundedBox( 4, 0, 0, 21, 18, Color( 60, 60, 60, 150 ) )
		        draw.SimpleTextOutlined(tostring( LocalPlayer():Health() ), "Trebuchet22", 10, 8, Color(255, 100, 100, 200),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200) )
		    cam.End3D2D()
		    
		    if LocalPlayer():Armor() > 0 then
			    cam.Start3D2D( pos - ( ang:Right() * 12 ) + ( ang:Forward() * 7 ), ang , 0.25 )
			        draw.RoundedBox( 4, 0, 0, 16, 15, Color( 60, 60, 60, 150 ) )
			        draw.SimpleTextOutlined(tostring( LocalPlayer():Armor() ), "Trebuchet19", 8, 8, Color(100, 100, 255, 200),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200) )
			    cam.End3D2D()
			end
		elseif !plydamaged and displaydamage then
			if alpha > 5 then
				alpha = Lerp( 0.2, alpha, 0 )
				pos, ang = LocalPlayer():GetBonePosition(LocalPlayer():LookupBone("ValveBiped.Bip01_Head1"))
			    ang:RotateAroundAxis( ang:Up(), 90 )
			    ang:RotateAroundAxis( ang:Forward() , -180 )
			    ang:RotateAroundAxis( ang:Right() , -90 )
			    cam.Start3D2D( pos - ( ang:Right() * 18 ), ang , 0.25 )
			        draw.RoundedBox( 4, 0, 0, 21, 18, Color( 60, 60, 60, alpha ) )
			        draw.SimpleTextOutlined(tostring( LocalPlayer():Health() ), "Trebuchet22", 10, 8, Color(255, 100, 100, alpha),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200) )
			    cam.End3D2D()
			    
			    if LocalPlayer():Armor() > 0 then
				    cam.Start3D2D( pos - ( ang:Right() * 12 ) + ( ang:Forward() * 7 ), ang , 0.25 )
				        draw.RoundedBox( 4, 0, 0, 16, 15, Color( 60, 60, 60, alpha ) )
				        draw.SimpleTextOutlined(tostring( LocalPlayer():Armor() ), "Trebuchet19", 8, 8, Color(100, 100, 255, alpha),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200) )
				    cam.End3D2D()
				end
			else
				alpha = 150
				displaydamage = false
			end
		end

		ent = LocalPlayer():GetActiveWeapon()

		if ( ValidEntity( ent ) and LocalPlayer():GetAiming() ) or ( CAKE.MenuOpen and ValidEntity( ent ) ) then
		    ammotext = tostring( ent:Clip1() ) .. "/" .. tostring( LocalPlayer():GetAmmoCount(ent:GetPrimaryAmmoType()) )
		    pos, ang = LocalPlayer():GetBonePosition(LocalPlayer():LookupBone("ValveBiped.Bip01_R_Hand"))
		    ang:RotateAroundAxis( ang:Up(), 90 )
		    ang:RotateAroundAxis( ang:Forward() ,-90 )
		    ang:RotateAroundAxis( ang:Right() ,0 )

		    if ent:Clip1() >= 0 and ent:GetClass() != "weapon_physcannon" then
		        cam.Start3D2D( pos - (ang:Right() * 10) + (ang:Forward() * 5), ang , 0.2 )
		        	if ent.Primary and ent.Primary.ClipSize then
		        		perc = ent:Clip1() / ent.Primary.ClipSize
		        	else
		        		perc = 1
		        	end
		            surface.SetFont("Trebuchet24")
		            textsizex, textsizey = surface.GetTextSize( ammotext )
		            draw.RoundedBox( 4, 0, 0, textsizex * perc, textsizey / 2 , Color( 60, 60, 60, 150 ) )
		            draw.SimpleTextOutlined(ammotext, "Trebuchet24", textsizex / 2, 0, Color(180, 255, 180, 200),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200))
		            if LocalPlayer():GetAmmoCount(ent:GetSecondaryAmmoType()) > 0 then
		                surface.SetFont("Trebuchet20")
		                textsizex, textsizey = surface.GetTextSize( tostring( LocalPlayer():GetAmmoCount(ent:GetSecondaryAmmoType()) ) )
		                draw.RoundedBox( 4, 50, 30, textsizex, textsizey / 2, Color( 60, 60, 60, 150 ) )
		                draw.SimpleTextOutlined(tostring( LocalPlayer():GetAmmoCount(ent:GetSecondaryAmmoType()) ), "Trebuchet20", (textsizex / 2 ) + 50, 30, Color(180, 180, 255, 200),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200))
		                if LocalPlayer():GetAmmoCount(ent:GetSecondaryAmmoType()) > 0 then
			                surface.SetFont("HUDNumber")
			                textsizex, textsizey = surface.GetTextSize( tostring( LocalPlayer():GetAmmoCount(ent:GetSecondaryAmmoType()) ) )
			                draw.RoundedBox( 4, ScrW() - 160, ScrH() - 100, textsizex, textsizey / 2, Color( 60, 60, 60, 150 ) )
			                draw.SimpleTextOutlined(tostring( LocalPlayer():GetAmmoCount(ent:GetSecondaryAmmoType()) ), "HUDNumber", ( ScrW() - 160 ) + (textsizex / 2 ), ScrH() - 100, Color(180, 180, 255, 200),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200))
			            end
		            end
		        cam.End3D2D()
		    end
		end
	end

end)

hook.Add( "Think", "TiramisuDamageDetect",function() 

	if !LocalPlayer().TiramisuHUDDamage then
		LocalPlayer().TiramisuHUDDamage = LocalPlayer():Health()
	end

	if LocalPlayer().TiramisuHUDDamage != LocalPlayer():Health() and LocalPlayer():Health() < 100 then
		plydamaged = true
		LocalPlayer().TiramisuHUDDamage = LocalPlayer():Health()
		timer.Create("LocalDamageDisplayTimer", 3, 1, function()
			plydamaged = false
		end)
	end
	
end)

local pos
local trace
hook.Add( "HUDPaint", "TiramisuHUDDraw", function()
	
	if CAKE.Thirdperson:GetBool() then
		if LocalPlayer():GetAiming() then
			trace = LocalPlayer():GetEyeTrace()
			pos = trace.HitPos:ToScreen()
			if pos.visible then
				if !trace.HitWorld then
					surface.SetDrawColor( 200, 50, 50, 220 )
				else
					surface.SetDrawColor( 220, 220, 220, 220 )
				end
				surface.DrawLine( pos.x - 5, pos.y, pos.x + 5, pos.y )
				surface.DrawLine( pos.x, pos.y - 5, pos.x, pos.y + 5 )
			end
		end
	else
		
		surface.SetFont("HUDNumber")
		textsizex, textsizey = surface.GetTextSize(tostring( LocalPlayer():Health() ) )
		draw.RoundedBox( 4, 30, ScrH() - 70, textsizex, textsizey, Color( 60, 60, 60, 150 ) )
        draw.SimpleTextOutlined(tostring( LocalPlayer():Health() ), "HUDNumber", 30 + textsizex / 2, ScrH() - 50, Color(255, 100, 100, 200),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200) )

        if LocalPlayer():Armor() > 0 then
        	textsizex, textsizey = surface.GetTextSize(tostring( LocalPlayer():Armor() ) )
	        draw.RoundedBox( 4, 100, ScrH() - 70, textsizex, textsizey, Color( 60, 60, 60, 150 ) )
	        draw.SimpleTextOutlined(tostring( LocalPlayer():Armor() ), "HUDNumber", 80 + textsizex, ScrH() - 50, Color(100, 100, 255, 200),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200) )
    	end

		ent = LocalPlayer():GetActiveWeapon()
    
	    if ( ValidEntity( ent ) and LocalPlayer():GetAiming() ) or ( CAKE.MenuOpen and ValidEntity( ent ) ) then
	        ammotext = tostring( ent:Clip1() ) .. "/" .. tostring( LocalPlayer():GetAmmoCount(ent:GetPrimaryAmmoType()) )
	        if ent:Clip1() >= 0 and ent:GetClass() != "weapon_physcannon" then
	            if ent.Primary and ent.Primary.ClipSize then
	                perc = ent:Clip1() / ent.Primary.ClipSize
	            else
	                perc = 1
	            end
	            surface.SetFont("HUDNumber")
	            textsizex, textsizey = surface.GetTextSize( ammotext )
	            draw.RoundedBox( 4, ScrW() - 160, ScrH() - 50, textsizex * perc, textsizey / 2 , Color( 60, 60, 60, 150 ) )
	            draw.SimpleTextOutlined(ammotext, "HUDNumber", ( ScrW() - 160 ) + textsizex / 2, ScrH() - 50, Color(180, 255, 180, 200),TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color(10,10,10,200))
	        end
	    end

	end
	
end)

hook.Add( "HUDShouldDraw", "TiramisuHideHL2Crosshair", function( name )
	
	if CAKE.Thirdperson:GetBool() then
		if name == "CHudCrosshair" then
			return false
		end
	end

end )