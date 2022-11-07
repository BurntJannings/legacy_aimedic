local createdped = 0
local wagon = 0
local VORPcore = {}
local amount 
local close

TriggerEvent("getCore", function(core)
    VORPcore = core
end)

RegisterCommand(Config.doctors.command,function(source)

	TriggerServerEvent("legacy_medic:getjob")
	
end)



RegisterNetEvent('legacy_medic:findjob')
AddEventHandler('legacy_medic:findjob', function(docs)
    if IsEntityDead(PlayerPedId()) then
        VORPcore.NotifyRightTip(Config.Language.calldoctor,4000)
        SpawnNPC()
    else
        VORPcore.NotifyRightTip(Config.Language.notdead,4000)
    end
end)

function SpawnNPC()

	local model = GetHashKey(Config.doctors.ped)
					RequestModel(model)
					if not HasModelLoaded(model) then 
						RequestModel(model) 
					end
					while not HasModelLoaded(model) or HasModelLoaded(model) == 0 or model == 1 do
						Citizen.Wait(1) 
					end
    for k, v in pairs(Config.doctors) do

  	local coords = GetEntityCoords(PlayerPedId())
        local randomAngle = math.rad(math.random(0, 360))
        local x = coords.x + math.sin(randomAngle) * math.random(1, 100) * 0.5
        local y = coords.y + math.cos(randomAngle) * math.random(1, 100) * 0.5 -- End Number multiplied by is radius to player
        local z = coords.z
        local b, rdcoords, rdcoords2 = GetClosestVehicleNode(coords.x, coords.y, coords.z, 1, 10.0, 10.0)
        if (rdcoords.x == 0.0 and rdcoords.y == 0.0 and rdcoords.z == 0.0) then
            local valid, outPosition = GetSafeCoordForPed(x, y, z, false, 8)
            if valid then
                x = outPosition.x
                y = outPosition.y
                z = outPosition.z
            end
        else
            local inwater = Citizen.InvokeNative(0x43C851690662113D, createdped, 100)
            if inwater then
             DeleteEntity(createdped)
             VORPcore.NotifyRightTip(Config.Language.inwater,4000)
            end
            local valid, outPosition = GetSafeCoordForPed(x, y, z, false, 16)
            if valid then
                x = outPosition.x
                y = outPosition.y
                z = outPosition.z
            end

            local foundground, groundZ, normal = GetGroundZAndNormalFor_3dCoord(x, y, z)
            if foundground then
                z = groundZ
            else
                VORPcore.NotifyRightTip(Config.Language.missground,4000)
                DeleteEntity(createdped)
            end
        end


					if createdped == 0 then
						createdped = CreatePed(model, x+2.0, y, z ,true, true, true, true)
						Wait(500)
                    else
                        DeleteEntity(createdped)
                        VORPcore.NotifyRightTip(Config.Language.doctordied,4000)
                        createdped = 0
					end

					Citizen.InvokeNative(0x283978A15512B2FE, createdped, true) 

                    local ped = PlayerPedId()    
                    FreezeEntityPosition(createdped, false)
                    Citizen.InvokeNative(0x923583741DC87BCE, createdped, "default")
                    TaskGoToEntity(createdped, ped, -1, 2.0, 5.0, 1073741824, 1)
                    Wait(0)
                    while createdped do 
                        local pcoords = GetEntityCoords(PlayerPedId())
                        local tcoords = GetEntityCoords(createdped)
                        local distance = Vdist2(pcoords.x,pcoords.y,pcoords.z,tcoords.x,tcoords.y,tcoords.z)
                        Wait(0)
                        if distance < 5 then       
                            if createdped then 
                            Wait(5000)
                            DeleteEntity(createdped)
				TriggerServerEvent('legacy_medic:reviveplayer', source)
                            end
                        end

                    end
    end
end

RegisterNetEvent("legacy_medic:revive")
AddEventHandler("legacy_medic:revive", function()
    TriggerEvent('vorp:resurrectPlayer', source)
end)
