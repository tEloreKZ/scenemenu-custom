--AddSpeedZoneForCoord(float x, float y, float z, float radius, float speed, BOOL p5);

local speedZoneActive = false
local blip
local speedZone
local speedzones = {}


_menuPool = NativeUI.CreatePool()
trafficmenu = NativeUI.CreateMenu("Меню сцены", "~b~Помощник трафик-сцен")
_menuPool:Add(trafficmenu)


function ShowNotification(text)
  SetNotificationTextEntry("STRING")
  AddTextComponentString(text)
  DrawNotification(false, false)
end

function ObjectsSubMenu(menu)
  local submenu = _menuPool:AddSubMenu(menu, "Меню объектов")

  local objects = { }

  for k,v in pairs(Config.Objects) do 
    for k,v in pairs(v) do 
        if k == "Displayname" then
          table.insert(objects, v)
        end
    end
  end

  local objectlist = NativeUI.CreateListItem("Спавн объектов", objects, 1, "Нажмите Enter что бы заспавнить выбранный объект.")
  local deletebutton = NativeUI.CreateItem("Удалить", "Удалить ближайший объект.")


  submenu:AddItem(deletebutton)
  deletebutton.Activated = function(sender, item, index)
    local x, y, z = table.unpack(GetEntityCoords(PlayerPedId(), true))

    for k,v in pairs(Config.Objects) do 
      
      local hash = GetHashKey(v.Object)
      if DoesObjectOfTypeExistAtCoords(x, y, z, 0.9, hash, true) then
        local object = GetClosestObjectOfType(x, y, z, 0.9, hash, false, false, false)
        DeleteObject(object)
      end

    end

  end


  submenu:AddItem(objectlist)
  objectlist.OnListSelected = function(sender, item, index)
    local Player = GetPlayerPed(-1)
    local heading = GetEntityHeading(Player)
    local x, y, z = table.unpack(GetEntityCoords(Player, true))
    local object = item:IndexToItem(index)

    for k,v in pairs(Config.Objects) do 
        if v.Displayname == object then
          print(v.Object)
          local objectname = v.Object
          RequestModel(objectname)
          while not HasModelLoaded(objectname) do
            Citizen.Wait(1)
          end
          local obj = CreateObject(GetHashKey(objectname), x, y, z, true, false);
          PlaceObjectOnGroundProperly(obj)
          SetEntityHeading(obj, heading)
          FreezeEntityPosition(obj, true)
        end
    end

  end
  

end

function SpeedZoneSubMenu(menu)
  local submenu = _menuPool:AddSubMenu(menu, "Скоростная зона")
  local radiusnum = { }

  local speednum = { }

  for k,v in pairs(Config.SpeedZone.Radius) do 
    table.insert(radiusnum, v)
  end

  for k,v in pairs(Config.SpeedZone.Speed) do 
    table.insert(speednum, v)
  end

  local zonecreate = NativeUI.CreateItem("Создать зону", "Создает зону с указанным радиусом и скоростью.")
  local zoneradius = NativeUI.CreateSliderItem("Радиус", radiusnum, 1, false)
  local zonespeed = NativeUI.CreateListItem("Скорость", speednum, 1)
  local zonedelete = NativeUI.CreateItem("Удалить зону", "Удалить вашу зону.")

  submenu:AddItem(zoneradius)
  submenu:AddItem(zonespeed)
  submenu:AddItem(zonecreate)
  submenu:AddItem(zonedelete)

  zonecreate:SetRightBadge(BadgeStyle.Tick)

  submenu.OnSliderChange = function(sender, item, index)
        radius = item:IndexToItem(index)
        ShowNotification("Изменить радиус на ~r~" .. radius)
  end

  submenu.OnListChange = function(sender, item, index)
    speed = item:IndexToItem(index)
    ShowNotification("Изменить скорость на ~r~" .. speed)
  end

  zonedelete.Activated = function(sender, item, index)
      TriggerServerEvent('Отключить')
      ShowNotification("Отключить зону.")
  end

  zonecreate.Activated = function(sender, item, index)

      if not speed then
        speed = 0
      end

      if not radius then
        ShowNotification("~r~Пожалуйста измените радиус!")
        return
      end

          speedZoneActive = true
          ShowNotification("Создать скоростную зону.")
          local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
          radius = radius + 0.0
          speed = speed + 0.0
      
          local streetName, crossing = GetStreetNameAtCoord(x, y, z)
          streetName = GetStreetNameFromHashKey(streetName)

          TriggerServerEvent('ZoneActivated', message, speed, radius, x, y, z)
  end

end

local GlobalData = ""

RegisterNetEvent('ReturnData')
AddEventHandler('ReturnData', function(data)

  GlobalData = data

end)

ObjectsSubMenu(trafficmenu)
SpeedZoneSubMenu(trafficmenu)

if Config.ActivationMode == "Key" then
Citizen.CreateThread(function()
  while true do
      Citizen.Wait(0)
      _menuPool:ProcessMenus()
      if IsControlJustPressed(0, Config.ActivationKey) and GetLastInputMethod( 0 ) then

        if Config.UsageMode == "Ped" then

          pmodel = GetEntityModel(PlayerPedId())
          if inArrayPed(pmodel, Config.WhitelistedPeds) then
            trafficmenu:Visible(not trafficmenu:Visible())
          else 
            print("You are not in the correct ped to use this menu.")
          end

        elseif Config.UsageMode == "IP" then

          TriggerServerEvent("GetData", "IP")
          Wait(100)
          if inArray(GlobalData, Config.WhitelistedIPs) then
            trafficmenu:Visible(not trafficmenu:Visible())
          else 
            print("You are not whitelisted to use this.")
          end

        elseif Config.UsageMode == "Steam" then

          TriggerServerEvent("GetData", "Steam")
          Wait(100)
          if inArraySteam(GlobalData, Config.WhitelistedSteam) then
            trafficmenu:Visible(not trafficmenu:Visible())
          else 
            print("You are not whitelisted to use this.")
          end

        elseif Config.UsageMode == "Everyone" then
            trafficmenu:Visible(not trafficmenu:Visible())
        end

      end
  end
end)

elseif Config.ActivationMode == "Command" then

Citizen.CreateThread(function()
  while true do
      Citizen.Wait(0)
      _menuPool:ProcessMenus()
  end
end)

RegisterCommand(Config.ActivationCommand, function(source, args, rawCommand)
    if Config.UsageMode == "Ped" then

    pmodel = GetEntityModel(PlayerPedId())
    if inArrayPed(pmodel, Config.WhitelistedPeds) then
      trafficmenu:Visible(not trafficmenu:Visible())
    else 
      print("You are not in the correct ped to use this menu.")
    end

  elseif Config.UsageMode == "IP" then

    TriggerServerEvent("GetData", "IP")
    Wait(100)
    if inArray(GlobalData, Config.WhitelistedIPs) then
      trafficmenu:Visible(not trafficmenu:Visible())
    else 
      print("You are not whitelisted to use this.")
    end

  elseif Config.UsageMode == "Steam" then

    TriggerServerEvent("GetData", "Steam")
    Wait(100)
    if inArraySteam(GlobalData, Config.WhitelistedSteam) then
      trafficmenu:Visible(not trafficmenu:Visible())
    else 
      print("You are not whitelisted to use this.")
    end

  elseif Config.UsageMode == "Everyone" then
      trafficmenu:Visible(not trafficmenu:Visible())
  end
end, false)

end


RegisterNetEvent('Zone')
AddEventHandler('Zone', function(speed, radius, x, y, z)

  blip = AddBlipForRadius(x, y, z, radius)
      SetBlipColour(blip,idcolor)
      SetBlipAlpha(blip,80)
      SetBlipSprite(blip,9)
  speedZone = AddSpeedZoneForCoord(x, y, z, radius, speed, false)

  table.insert(speedzones, {x, y, z, speedZone, blip})

end)

RegisterNetEvent('RemoveBlip')
AddEventHandler('RemoveBlip', function()

    if speedzones == nil then
      return
    end
    local playerPed = GetPlayerPed(-1)
    local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
    local closestSpeedZone = 0
    local closestDistance = 1000
    for i = 1, #speedzones, 1 do
        local distance = Vdist(speedzones[i][1], speedzones[i][2], speedzones[i][3], x, y, z)
        if distance < closestDistance then
            closestDistance = distance
            closestSpeedZone = i
        end
    end
    RemoveSpeedZone(speedzones[closestSpeedZone][4])
    RemoveBlip(speedzones[closestSpeedZone][5])
    table.remove(speedzones, closestSpeedZone)

end)

function inArrayPed(value, array)
  for _,v in pairs(array) do
    if GetHashKey(v) == value then
      return true
    end
  end
  return false
end

function inArray(value, array)
  for _,v in pairs(array) do
    if v == value then
      return true
    end
  end
  return false
end

  -- Returns TRUE if value is in array, FALSE otherwise
  function inArraySteam(value, array)
    for _,v in pairs(array) do
      v = getSteamId(v)
      if v == value then
        return true
      end
    end
    return false
  end

-- Returns TRUE if steamId start with "steam:", FALSE otherwise
function isNativeSteamId(steamId)
  if string.sub(steamId, 0, 6) == "steam:" then
    return true
  end
  return false
end

function getSteamId(steamId)
  if not isNativeSteamId(steamId) then -- FiveM SteamID conversion
    steamId = "steam:" .. string.format("%x", tonumber(steamId))
  else
    steamId = string.lower(steamId) -- Lowercase conversion
  end
  return steamId
end

_menuPool:MouseControlsEnabled(false)
_menuPool:ControlDisablingEnabled(false)
















local PoliceModels = {}
local SpawnedSpikes = {}
local spikemodel = "P_ld_stinger_s"
local nearSpikes = false
local spikesSpawned = false

Citizen.CreateThread(function()
    while true do
        if IsPedInAnyVehicle(LocalPed(), false) then
            local vehicle = GetVehiclePedIsIn(LocalPed(), false)
            if GetPedInVehicleSeat(vehicle, -1) == LocalPed() then
                local vehiclePos = GetEntityCoords(vehicle, false)
                local spikes = GetClosestObjectOfType(vehiclePos.x, vehiclePos.y, vehiclePos.z, 80.0, GetHashKey(spikemodel), 1, 1, 1)
                local spikePos = GetEntityCoords(spikes, false)
                local distance = Vdist(vehiclePos.x, vehiclePos.y, vehiclePos.z, spikePos.x, spikePos.y, spikePos.z)

                if spikes ~= 0 then
                    nearSpikes = true
                else
                    nearSpikes = false
                end
            else
                nearSpikes = false
            end
        else
            nearSpikes = false
        end

        Citizen.Wait(0)
    end
end)

---------------------------------------------------------------------------
-- Tire Popping --
---------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        if nearSpikes then
            local tires = {
                {bone = "wheel_lf", index = 0},
                {bone = "wheel_rf", index = 1},
                {bone = "wheel_lm", index = 2},
                {bone = "wheel_rm", index = 3},
                {bone = "wheel_lr", index = 4},
                {bone = "wheel_rr", index = 5}
            }

            for a = 1, #tires do
                local vehicle = GetVehiclePedIsIn(LocalPed(), false)
                local tirePos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, tires[a].bone))
                local spike = GetClosestObjectOfType(tirePos.x, tirePos.y, tirePos.z, 15.0, GetHashKey(spikemodel), 1, 1, 1)
                local spikePos = GetEntityCoords(spike, false)
                local distance = Vdist(tirePos.x, tirePos.y, tirePos.z, spikePos.x, spikePos.y, spikePos.z)

                if distance < 1.8 then
                    if not IsVehicleTyreBurst(vehicle, tires[a].index, true) or IsVehicleTyreBurst(vehicle, tires[a].index, false) then
                        SetVehicleTyreBurst(vehicle, tires[a].index, false, 1000.0)
                    end
                end
            end
        end

        Citizen.Wait(0)
    end
end)



Citizen.CreateThread(function()
    while true do
        local dev = false

        if dev then
            local plyOffset = GetOffsetFromEntityInWorldCoords(LocalPed(), 0.0, 2.0, 0.0)
            DrawMarker(0, plyOffset.x, plyOffset.y, plyOffset.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 2.0, 255, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0)
            local spike = GetClosestObjectOfType(plyOffset.x, plyOffset.y, plyOffset.z, 80.0, GetHashKey(spikemodel), 1, 1, 1)
            Citizen.Trace("NETID: " .. ObjToNet(spike))
        end
        Citizen.Wait(0)
    end
end)

function RemoveSpikes()
    for a = 1, #SpawnedSpikes do
        TriggerServerEvent("Spikes:TriggerDeleteSpikes", SpawnedSpikes[a])
    end
    SpawnedSpikes = {}
end

function LocalPed()
    return GetPlayerPed(PlayerId())  
end

function CheckPedRestriction(ped, pedList)
    for a = 1, #pedList do
        if GetHashKey(pedList[a]) == GetEntityModel(ped) then
            return true
        end
    end
    return false
end

function DisplayNotification(string)
  SetTextComponentFormat("STRING")
  AddTextComponentString(string)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

--------------------------------------------------------------

local holdingPackage          = false
local dropkey   = 246 -- Key to drop/get the props
local closestEntity = 0


-- Proplist, you can add as much as you want
attachPropList = {

 --{ Displayname = "Police Barrier", Object = "prop_barrier_work05" },
   -- { Displayname = "Big Cone", Object = "prop_roadcone01a" },
    --{ Displayname = "Small Cone", Object = "prop_roadcone02b" },
    --{ Displayname = "Gazebo", Object = "prop_gazebo_02" },
    --{ Displayname = "Scene Lights", Object = "prop_worklight_03b" },
    --{ Displayname = "Spikes", Object = "P_ld_stinger_s" }, 


    {["model"] = 'prop_cs_shopping_bag',                ["name"] = "bls",      ["bone"] = 57005, ["x"] = 0.4,  ["y"] = 0.0,  ["z"] = 0.05,   ["xR"] = 260.0, ["yR"] = 0.0, ["zR"] = 90.0,   ["anim"] = 'pick' }, -- Done
  --  {["model"] = 'prop_atm_01',                ["name"] = "Big Cone",      ["bone"] = 57005, ["x"] = 0.4,  ["y"] = 0.0,  ["z"] = 0.05,   ["xR"] = 260.0, ["yR"] = 0.0, ["zR"] = 90.0,   ["anim"] = 'pick' }, -- Done
    --{["model"] = 'prop_roadcone02b',                ["name"] = "Small Cone",      ["bone"] = 57005, ["x"] = 0.4,  ["y"] = 0.0,  ["z"] = 0.05,   ["xR"] = 260.0, ["yR"] = 0.0, ["zR"] = 90.0,   ["anim"] = 'pick' }, -- Don
    --{["model"] = 'prop_worklight_03b',                ["name"] = "Scene Lights",      ["bone"] = 57005, ["x"] = 0.4,  ["y"] = 0.0,  ["z"] = 0.05,   ["xR"] = 260.0, ["yR"] = 0.0, ["zR"] = 90.0,   ["anim"] = 'pick' }, -- Done
    --{["model"] = 'P_ld_stinger_s',                ["name"] = "Spikes",      ["bone"] = 57005, ["x"] = 0.4,  ["y"] = 0.0,  ["z"] = 0.05,   ["xR"] = 260.0, ["yR"] = 0.0, ["zR"] = 90.0,   ["anim"] = 'pick' }, -- Done

}

RegisterNetEvent('inrp_propsystem:attachProp')
AddEventHandler('inrp_propsystem:attachProp', function(attachModelSent,boneNumberSent,x,y,z,xR,yR,zR)
    notifi("~r~Y~w~ поставить                    ~r~ /r~w~ удалить", true, false, 120)
    closestEntity = 0
    holdingPackage = true
    local attachModel = GetHashKey(attachModelSent)
    SetCurrentPedWeapon(GetPlayerPed(-1), 0xA2719263) 
    local bone = GetPedBoneIndex(GetPlayerPed(-1), boneNumberSent)
    RequestModel(attachModel)
    while not HasModelLoaded(attachModel) do
        Citizen.Wait(0)
    end
    closestEntity = CreateObject(attachModel, 1.0, 1.0, 1.0, 1, 1, 0)
    for i=1 ,#attachPropList , 1 do
        if (attachPropList[i].model == attachModelSent) and (attachPropList[i].anim == 'hold') then
            holdAnim()
        end
    end
    Citizen.Wait(200)
    AttachEntityToEntity(closestEntity, GetPlayerPed(-1), bone, x, y, z, xR, yR, zR, 1, 1, 0, true, 2, 1)
end)

function notifi(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, false, 3000)
end

function loadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(0)
    end
end

function randPickupAnim()
  local randAnim = math.random(7)
    loadAnimDict('random@domestic')
    TaskPlayAnim(GetPlayerPed(-1),'random@domestic', 'pickup_low',1.0, 1.0, 1.0, 48, 0.0, 0, 0, 0)
end

function holdAnim()
    loadAnimDict( "anim@heists@box_carry@" )
    TaskPlayAnim((GetPlayerPed(-1)),"anim@heists@box_carry@","idle",4.0, 1.0, -1,49,0, 0, 0, 0)
end

Citizen.CreateThread( function()
    while true do 
        Citizen.Wait(10)        
        if IsPedOnFoot(GetPlayerPed(-1)) and not IsPedDeadOrDying(GetPlayerPed(-1)) then
            if IsControlJustReleased(0, dropkey) then
                local playerPed = PlayerPedId()
                local coords    = GetEntityCoords(playerPed)
                local closestDistance = -1
                closestEntity   = 0
                for i=1, #attachPropList, 1 do
                    local object = GetClosestObjectOfType(coords, 1.5, GetHashKey(attachPropList[i].model), false, false, false)
                    if DoesEntityExist(object) then
                        local objCoords = GetEntityCoords(object)
                        local distance  = GetDistanceBetweenCoords(coords, objCoords, true)
                        if closestDistance == -1 or closestDistance > distance then
                            closestDistance = distance
                            closestEntity   = object
                            if not holdingPackage then
                                local dst = GetDistanceBetweenCoords(GetEntityCoords(closestEntity) ,GetEntityCoords(GetPlayerPed(-1)),true)                 
                                if dst < 2 then
                                    holdingPackage = true
                                    if attachPropList[i].anim == 'pick' then
                                        randPickupAnim()
                                    elseif attachPropList[i].anim == 'hold' then
                                        holdAnim()
                                    end
                                    Citizen.Wait(550)
                                    NetworkRequestControlOfEntity(closestEntity)
                                    while not NetworkHasControlOfEntity(closestEntity) do
                                        Wait(0)
                                    end
                                    SetEntityAsMissionEntity(closestEntity, true, true)
                                    while not IsEntityAMissionEntity(closestEntity) do
                                        Wait(0)
                                    end
                                    SetEntityHasGravity(closestEntity, true)
                                    AttachEntityToEntity(closestEntity, GetPlayerPed(-1),GetPedBoneIndex(GetPlayerPed(-1), attachPropList[i].bone), attachPropList[i].x, attachPropList[i].y, attachPropList[i].z, attachPropList[i].xR, attachPropList[i].yR, attachPropList[i].zR, 1, 1, 0, true, 2, 1)
                                end
                            else
                                holdingPackage = false
                                if attachPropList[i].anim == 'pick' then
                                    randPickupAnim()
                                end
                                Citizen.Wait(350)
                                DetachEntity(closestEntity)
                                ClearPedTasks(GetPlayerPed(-1))
                                ClearPedSecondaryTask(GetPlayerPed(-1))
                            end
                        end
                        break
                    end
                end
            end
        else
            Citizen.Wait(500)
        end
    end
end)

function removeAttachedProp()
    if DoesEntityExist(closestEntity) then
        DeleteEntity(closestEntity)
    end
end

function attach(prop)
    TriggerEvent("inrp_propsystem:attachItem",prop)
end

function removeall()
    TriggerEvent("RemoveItems",false)
    ClearPedTasks(GetPlayerPed(-1))
    ClearPedSecondaryTask(GetPlayerPed(-1))
end

RegisterNetEvent('inrp_propsystem:attachItem')
AddEventHandler('inrp_propsystem:attachItem', function(item)
    for i=1 ,#attachPropList , 1 do
        if (attachPropList[i].model == item) then
            TriggerEvent("inrp_propsystem:attachProp",attachPropList[i].model, attachPropList[i].bone, attachPropList[i].x, attachPropList[i].y, attachPropList[i].z, attachPropList[i].xR, attachPropList[i].yR, attachPropList[i].zR)
        end
    end
end)

RegisterNetEvent("RemoveItems")
AddEventHandler("RemoveItems", function(sentinfo)
    SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("weapon_unarmed"), 1)
    removeAttachedProp()
    holdingPackage = false
end)


Citizen.CreateThread( function()
    RegisterCommand("r", function()
        removeall()
    end, false)
            
    for i=1, #attachPropList, 1 do
        RegisterCommand(attachPropList[i].name, function(source, args, raw)
            local arg = args[1]

            if arg == nil then
                attach(attachPropList[i].model)
            end
            
        end, false)
    end
    
end)


Citizen.CreateThread(function() while true do Citizen.Wait(30000) collectgarbage() end end) -- Prevents RAM LEAKS :)