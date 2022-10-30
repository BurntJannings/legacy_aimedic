local VorpCore = {}
TriggerEvent("getCore", function(core)
  VorpCore = core
end)

local VORPInv = {}

VORPInv = exports.vorp_inventory:vorp_inventoryApi()

RegisterServerEvent("legacy_medic:reviveplayer")
AddEventHandler("legacy_medic:reviveplayer", function()
  print("triggered")
    local _source = source
    local Character = VorpCore.getUser(_source).getUsedCharacter
    local money = Character.money
    if money >= Config.doctors.amount then
      Character.removeCurrency(0, Config.doctors.amount) -- Remove money 1000 | 0 = money, 1 = gold, 2 = rol
    VorpCore.NotifyRightTip(_source,Config.Language.revived..Config.doctors.amount,4000)
        TriggerClientEvent('legacy_medic:revive', _source)
    else

        VorpCore.NotifyRightTip(_source,Config.Language.notenough..Config.doctors.amount,4000)

    end
end)

RegisterServerEvent("legacy_medic:getjob")
AddEventHandler("legacy_medic:getjob", function()
    local _source = source
    local docs = 0
    for z, m in ipairs(GetPlayers()) do
        local User = VorpCore.getUser(m)
        local used = User.getUsedCharacter


          if CheckTable(Config.doctors.job, used.job) then
              docs = docs + 1

            end
    end 

    if docs == 0 then
      TriggerClientEvent('legacy_medic:findjob', _source)

    end

    if docs >= 1 then
      VorpCore.NotifyRightTip(_source,Config.Language.doctoractive,4000)
      end
end)

function CheckTable(table, element)
  for k, v in pairs(table) do
      if v == element then
          return true
      end
  end
  return false
end
