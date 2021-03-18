-- Scene Menu - By Kye Jones (123LladdCae)
-- This config file was created to help you configure the code in server.lua and client.lua a lot easier. Please do NOT edit those files.
Config = {}

Config.UsageMode = "Everyone" -- Who can use the menu? Options: 'Everyone', 'Steam', 'IP', 'Ped'
Config.ActivationMode = "Key" -- Choose how the menu is opened, options are: 'Key','Command'. 
Config.ActivationKey = 57 -- Use the following link to find the numbers, default 40 = ъ: https://docs.fivem.net/game-references/controls/ | 57 = F11
Config.ActivationCommand = "scenemenu" -- The command used to open the menu if ActivationMode is 'Command'. (Automatically adds /)


--[[

USED WITH 'Ped' MODE!

Array below is a list of peds that are allowed to use the menu.
If the player activating is not in a ped in here, the menu will not open.
Ignore if not using Ped mode
Add peds following the template below...

]]--
Config.WhitelistedPeds = { 
}

--[[

USED WITH 'IP' MODE!

Array below is a list of IPs that are allowed to use the menu.
If the player's IP isn't included in the list below, the menu will not open.
Ignore if not using the IP mode.
Add IPs following the template below...

]]--
Config.WhitelistedIPs = { 
}

--[[

USED WITH 'Steam' MODE!

Array below is a list of steam ID's that are allowed to use the menu.
If the player's SteamID64 isn't included in the list below, the menu will not open.
Ignore if not using the Steam mode.
MUST USE STEAMID64!! Can be found in many sites like: https://steamid.io/
Add peds following the template below...

]]--
Config.WhitelistedSteam = { 
}

--[[
-- OBJECT CONFIGURATION! --

This is the configuration section to add objects to the object menu and remove existing ones too!

To add an object, simply follow the below template and add it between the dashed lines below...

 { Displayname = "OBJECTNAME", Object = "SPAWNCODE" },

]]--
Config.Objects = {
    { Displayname = "Police Barrier", Object = "prop_barrier_work05" },
    { Displayname = "Big Cone", Object = "prop_roadcone01a" },
    { Displayname = "Small Cone", Object = "prop_roadcone02b" },
    { Displayname = "Gazebo", Object = "prop_gazebo_02" },
    { Displayname = "Scene Lights", Object = "prop_worklight_03b" },
	{ Displayname = "Work Barrier", Object = "prop_barrier_work06a" },
	{ Displayname = "Work Barrier2", Object = "prop_barrier_work06b" },
	{ Displayname = "Work Barrier3", Object = "prop_barrier_work01b" },
	{ Displayname = "Work Barrier4", Object = "prop_barrier_work04a" },
	{ Displayname = "Work Sign", Object = "prop_consign_01a" },
	{ Displayname = "Work Sign2", Object = "prop_consign_01b" },

    { Displayname = "BLS", Object = "prop_cs_shopping_bag" },

	
	
    ---------------------------------------------------------------
    ---------------------- Add more below! ------------------------
    -----------------------v-------------v-------------------------

	{ Displayname = "Police Marker #1", Object = "ril1" },
	{ Displayname = "Police Marker #2", Object = "ril2" },
	{ Displayname = "Police Marker #3", Object = "ril3" },
	{ Displayname = "Police Marker #4", Object = "ril4" },
	{ Displayname = "Police Marker #5", Object = "ril5" },
	{ Displayname = "Police Marker #6", Object = "ril6" },
	
	
	{ Displayname = "Bodybag", Object = "prop_ld_binbag_01" },
	{ Displayname = "Defibrillator", Object = "prop_ld_case_01" },
	

    ---------------------------------------------------------------
}


----------------------- SPEED ZONE CONFIG! ------------------------
--[[

Add/Remove/Change the options for radius and speed when setting a zone below.

]]--
Config.SpeedZone = {
    Radius = {'25', '50', '75', '100', '125', '150', '175', '200'},
    Speed = {'0', '5', '10', '15', '20', '25', '30', '35', '40', '45', '50'},
}
--[[ 
The message that shows in chat when speed zone is placed. Set to false to disable.
]]--
Config.TrafficAlert = false