local SpawnBatu                  = 0
local EntityBatu                 = {}
local zoneAmbilBatu
GlobalState['cekDutyPenambang']  = false
GlobalState['actionPenambang']   = false

--- [Function Pengeboran Batu] ---
function ZonaPengeboranBatu()
    for k, v in pairs(Nzdx.PengeboranBatu) do
        zoneAmbilBatu = lib.zones.poly({
            points    = v.PolyZonePengeboran,
            thickness = 20,
            debug     = false,

            inside = function ()
                local coords  = GetEntityCoords(cache.ped)
                local JarakB  = #(coords - v.LokasiPengeboran)
                if JarakB < 15 then
                    SpawnBatuPenambang(v.PropPengeboran, v.LokasiPengeboran)
                    Wait(500)
                else
                    Wait(500)
                end
            end,
        
            onEnter = function ()
                exports[Nzdx.NamaTarget]:AddTargetModel(v.PropPengeboran, {
                    options = {
                        {
                            icon    = "fas fa-hands",
                            label   = "Memecahkan Batu",
                            action  = function()
                                NzdxDapatkanBatu()
                            end,
                            canInteract = function(entity) 
                                return GlobalState['cekDutyPenambang'] and not GlobalState['actionPenambang']
                            end
                        },
                    },
                    distance = 1
                })
            end,
        
            onExit = function ()
                exports[Nzdx.NamaTarget]:RemoveTargetModel(v.PropPengeboran, {'Memecahkan Batu'})
                for k, v in pairs(EntityBatu) do
                    DeleteObject(v)
                    SpawnBatu = 0
                end
            end
        })
    end
end

function HapusZonaPengeboranBatu()
    zoneAmbilBatu:remove()
    for k, v in pairs(EntityBatu) do
        DeleteObject(v)
    end
end

--- [Function Pesebaran Batu] ---
function SpawnObject(model, coords, cb)
	local model = (type(model) == 'number' and model or joaat(model))
    lib.requestModel(model)
    local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, true)
    SetModelAsNoLongerNeeded(model)
    PlaceObjectOnGroundProperly(obj)
    FreezeEntityPosition(obj, true)
    if cb then
        cb(obj)
    end
end

function SpawnBatuPenambang(Prop, Lokasi)
	while SpawnBatu < 15 do
		Wait(1)
		local LokasiBatu = HasilCoordsBatu(Lokasi)
		SpawnObject(Prop, LokasiBatu, function(obj)
			table.insert(EntityBatu, obj)
			SpawnBatu = SpawnBatu + 1
		end)
	end
end 

function validasiLokasiBatu(spawnCoords, area)
	if SpawnBatu > 0 then
		local validate = true
		for k, v in pairs(EntityBatu) do
            local JarakA  = #(spawnCoords - GetEntityCoords(v))
			if JarakA < 5 then
				validate = false
			end
		end

        local JarakB  = #(spawnCoords - area)
		if JarakB > 20 then
			validate = false
		end
		return validate
	else
		return true
	end
end

function HasilCoordsBatu(Lokasi)
	while true do
		Wait(1)
		local CoordsBatuX, CoordsBatuY
		math.randomseed(GetGameTimer())
		local modX   = math.random(-35, 35)
		Wait(100)
		math.randomseed(GetGameTimer())
		local modY   = math.random(-35, 35)
		CoordsBatuX  = Lokasi.x + modX
		CoordsBatuY  = Lokasi.y + modY
		local CoordsBatuZ = GetCoordsBatu(CoordsBatuX, CoordsBatuY)
		local coord  = vector3(CoordsBatuX, CoordsBatuY, CoordsBatuZ)
		if validasiLokasiBatu(coord, Lokasi) then
			return coord
		end
	end
end

function GetCoordsBatu(x, y)
	local groundCheckHeights = { 45, 46.0, 47.0, 48.0, 49.0, 50.0, 51.0, 52.0, 53.0, 54.0, 55.0 }
	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)
		if foundGround then
			return z
		end
	end
	return 53.85
end

--- [Function Pakaian Penambang] ---
function SetPakianPenambang()
	TriggerEvent('skinchanger:getSkin', function(skin)
		local setBaju

		if skin.sex == 0 then
			setBaju = Nzdx.BajuPenambang['bajudinas'].male
		else
			setBaju = Nzdx.BajuPenambang['bajudinas'].female
		end

		if setBaju then
			TriggerEvent('skinchanger:loadClothes', skin, setBaju)
		else
			Notif('Tidak Ada Baju')
		end
	end)
end

function GantiPakianPenambangOn()
    lib.requestAnimDict('clothingtie')
    TaskPlayAnim(cache.ped, 'clothingtie', 'try_tie_positive_a', 3.0, 1.0, -1, 49, 0, 0, 0, 0 )  
    Progressbar('Ganti Baju Kerja', 5000, function()
        GlobalState['cekDutyPenambang'] = true
        ClearPedTasks(cache.ped)
        SetPakianPenambang()
        ZonaPengeboranBatu()
        Notif('Anda Berhasil On Duty')
    end, function()
        GlobalState['cekDutyPenambang'] = false
    end)
end

function GantiPakianPenambangOff()
    lib.requestAnimDict('clothingtie')
    TaskPlayAnim(cache.ped, 'clothingtie', 'try_tie_positive_a', 3.0, 1.0, -1, 49, 0, 0, 0, 0 )  
    Progressbar('Ganti Baju', 5000, function()
        GlobalState['cekDutyPenambang'] = false
        ClearPedTasks(cache.ped)
        if Nzdx.PakaiIllenium then
            ExecuteCommand ("reloadskin")
        else
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                local isMale = skin.sex == 0
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                    TriggerEvent('skinchanger:loadSkin', skin)
                end)
            end)
        end

        HapusZonaPengeboranBatu()
        Notif('Anda Berhasil Off Duty')
    end, function()
        GlobalState['cekDutyPenambang'] = true
    end)
end

--- [Function Action Kerja] ---
function NzdxDapatkanBatu()
	local nearbyObject, nearbyID

    for i=1, #EntityBatu, 1 do
        local coords = GetEntityCoords(cache.ped)
		local Jarak  = #(coords - GetEntityCoords(EntityBatu[i]))
		if Jarak < 2.0 then
			nearbyObject, nearbyID = EntityBatu[i], i
		end
	end

    if nearbyObject and IsPedOnFoot(cache.ped) then
        axeProps = CreateObject(joaat("prop_tool_pickaxe"), 0, 0, 0, true, true, true)        
        AttachEntityToEntity(axeProps, cache.ped, GetPedBoneIndex(cache.ped, 57005), 0.1, -0.02, -0.02, -50.0, 0.00, 0.0, true, true, false, true, 1, true)
        if lib.progressBar({
            label           = "Memecahkan Batu",
            duration        = 5000,
            useWhileDead    = false,
            canCancel       = true,
            disable         = {
                move        = true
            },
            anim = {
                dict = "melee@hatchet@streamed_core",
                clip = "plyr_rear_takedown_b"
            }
        }) then
            DeleteObject(nearbyObject) 
            ESX.Game.DeleteObject(axeProps)
            table.remove(EntityBatu, nearbyID)
            SpawnBatu = SpawnBatu - 1

            for k, v in pairs(Nzdx.ActionKerja) do
                if k == 'Pengambilan_Batu' then
                    v.Action()
                end
            end
        end
    else
        Notif('Tidak Dapat Mengambil')
    end
end

function NzdxProsesBatu()
    FreezeEntityPosition(cache.ped, true)
    TaskStartScenarioInPlace(cache.ped, 'WORLD_HUMAN_BUM_WASH', 0, false)
    Progressbar('Mencuci Batu', 10000, function()
        ClearPedTasks(cache.ped)
        for k, v in pairs(Nzdx.ActionKerja) do
            if k == 'Pencucian_Batu' then
                v.Action()
            end
        end
    end)
end

function NzdxMeleburBatu()
    FreezeEntityPosition(cache.ped, true)
    TaskStartScenarioInPlace(cache.ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
    Progressbar('Meleburkan Batu', 10000, function()
        ClearPedTasks(cache.ped)
        for k, v in pairs(Nzdx.ActionKerja) do
            if k == 'Peleburan_Batu' then
                v.Action()
            end
        end
    end)
end

function NzdxMenjualTambang()
    lib.registerContext({
        id      = 'nzdx:penjualan',
        title   = 'Penjualan Tambang',
        options = {
            {
                title = 'Penjualan Permata',
                event = 'Nzdx-Penambang:Penjualan',
                args  = 'Penjualan_Permata'
            },

            {
                title = 'Penjualan Emas',
                event = 'Nzdx-Penambang:Penjualan',
                args  = 'Penjualan_Emas'
            },

            {
                title = 'Penjualan Besi',
                event = 'Nzdx-Penambang:Penjualan',
                args  = 'Penjualan_Besi'
            },

            {
                title = 'Penjualan Tembaga',
                event = 'Nzdx-Penambang:Penjualan',
                args  = 'Penjualan_Tembaga'
            },
        }
    })

    lib.showContext('nzdx:penjualan')
end

RegisterNetEvent('Nzdx-Penambang:Penjualan', function(data)
    for k, v in pairs(Nzdx.ActionKerja) do
        if k == data then
            v.Action()
        end
    end
end)

--- [Create Thread] ---
CreateThread(function()
    for k, v in pairs (Nzdx.LokasiPenambang) do
        if v.ActionTarget ~= nil and v.LabelZone ~= nil then
            exports[Nzdx.NamaTarget]:AddBoxZone(v.LabelZone, vector3(v.LokasiTempat[1], v.LokasiTempat[2], v.LokasiTempat[3]), 1, 2, {
                name        = v.LabelZone,
                heading     = v.LokasiTempat[4],
                debugPoly   = false,
                minZ        = v.LokasiTempat[3] - 1,
                maxZ        = v.LokasiTempat[3] + 3
            }, {
                options     = v.ActionTarget,
                distance    = 1.5
            })
        end

        if Nzdx.PakaiBlips == true then
            v.blip = AddBlipForCoord(v.LokasiTempat[1], v.LokasiTempat[2], v.LokasiTempat[3])
            SetBlipSprite (v.blip, v.BlipSetting.Jenis)
            SetBlipDisplay(v.blip, 4)
            SetBlipScale  (v.blip, v.BlipSetting.Ukuran)
            SetBlipColour (v.blip, v.BlipSetting.Warna)
            SetBlipAsShortRange(v.blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.NamaTempat)
            EndTextCommandSetBlipName(v.blip)
        end
    end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(EntityBatu) do
			DeleteObject(v)
		end

        HapusZonaPengeboranBatu()
	end
end)