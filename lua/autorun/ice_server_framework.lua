local rootDirectory = "ice_server_framework" 
local addonName = "-ICE- Server Framework" 
   
local function AddFile( File, directory ) 
	local prefix = string.lower( string.Left( File, 3 ) )
  
	if SERVER and prefix == "sv_" then  
		include( directory..File ) 
		print( "["..addonName.."] Included Server File: " .. File )
	elseif prefix == "sh_" then  
		if SERVER then  						
			AddCSLuaFile( directory..File )
			print( "["..addonName.."] Included Shared File: " .. File )
		end
		include( directory..File )
		print( "["..addonName.."] Included Shared File: " .. File )
	elseif prefix == "cl_" then
		if SERVER then 
			AddCSLuaFile( directory..File )
			print( "["..addonName.."] Included Client File: " .. File )
		elseif CLIENT then
			include( directory..File )
			print( "["..addonName.."] Included Client File: " .. File )
		end
	end
end

local function IncludeDir( directory )
	directory = directory .. "/"

	local files, directories = file.Find( directory .. "*", "LUA" )

	for _, v in ipairs( files ) do
		if string.EndsWith( v, ".lua" ) then
			AddFile( v, directory )
		end
	end

	for _, v in ipairs( directories ) do
		print( "["..addonName.."] Directory: " .. v )
		IncludeDir( directory .. v )
	end 
end

IncludeDir( rootDirectory )

