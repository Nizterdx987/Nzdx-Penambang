Nzdx = {}

Nzdx.PakaiIllenium   = false
Nzdx.NamaTarget      = 'qtarget'
Nzdx.PakaiBlips      = true

Nzdx.PengeboranBatu  = {
    [1] = {
        LokasiPengeboran    = vec3(2952.0315, 2790.2886, 41.3742),
        PropPengeboran      = "prop_rock_1_e",
        PolyZonePengeboran  = {
            vec3(2926.0, 2824.0, 45.0),
            vec3(2954.0, 2831.0, 45.0),
            vec3(2979.0, 2816.0, 45.0),
            vec3(2987.0, 2790.0, 45.0),
            vec3(2984.0, 2766.0, 45.0),
            vec3(2956.0, 2754.0, 45.0),
            vec3(2935.0, 2763.0, 45.0),
            vec3(2912.0, 2790.0, 45.0),
        },
    }
}

Nzdx.LokasiPenambang    = {
    [1] = {
        NamaTempat      = 'Penambang - Ganti Baju',
        LabelZone       = 'Zona-GantiBaju',
        LokasiTempat    = {892.3263, -2171.8960, 32.2862, 358.4385},
        BlipSetting     = {
            Ukuran      = 0.7,
            Warna       = 5,
            Jenis       = 318
        },
        ActionTarget    = {
            {
                icon        = 'fas fa-tint',
                label       = 'On Duty',
                action  = function()
                    GantiPakianPenambangOn()
                end,
                canInteract = function(entity) 
                    return not GlobalState['cekDutyPenambang']
                end
            },

            {
                icon        = 'fas fa-tint',
                label       = 'Off Duty',
                action  = function()
                    GantiPakianPenambangOff()
                end,
                canInteract = function(entity) 
                    return GlobalState['cekDutyPenambang'] and not GlobalState['actionPenambang']
                end
            },
        }
    },

    [2] = {
        NamaTempat      = 'Penambang - Area Pengeboran',
        LabelZone       = nil,
        LokasiTempat    = {2953.0857, 2787.4810, 41.4758, 226.4172},
        BlipSetting     = {
            Ukuran      = 0.7,
            Warna       = 5,
            Jenis       = 318
        },
        ActionTarget    = nil
    },

    [3] = {
        NamaTempat      = 'Penambang - Pencucian Batu',
        LabelZone       = 'Zona-PencucianBatu',
        LokasiTempat    = {186.1488, 2786.3572, 46.0244, 95.5579},
        BlipSetting     = {
            Ukuran      = 0.7,
            Warna       = 5,
            Jenis       = 318
        },
        ActionTarget    = {
            {
				icon 		= "fas fa-box-open",
				label 		= "Memoleskan Batu",
                action      = function()
                    NzdxProsesBatu()
                end,
                canInteract = function(entity) 
                    return GlobalState['cekDutyPenambang'] and not GlobalState['actionPenambang']
                end
            }
        }
    },

    [4] = {
        NamaTempat      = 'Penambang - Peleburan Batu',
        LabelZone       = 'Zona-PeleburanBatu',
        LokasiTempat    = {1109.9625, -2008.2465, 30.0615, 238.9492},
        BlipSetting     = {
            Ukuran      = 0.7,
            Warna       = 5,
            Jenis       = 318
        },
        ActionTarget    = {
            {
				icon 		= "fas fa-box-open",
				label 		= "Meleburkan Batu",
                action      = function()
                    NzdxMeleburBatu()
                end,
                canInteract = function(entity) 
                    return GlobalState['cekDutyPenambang'] and not GlobalState['actionPenambang']
                end
            }
        }
    },

    [5] = {
        NamaTempat      = 'Penambang - Penjualan Tambang',
        LabelZone       = 'Zona-PenjualanTambang',
        LokasiTempat    = {2899.2180, 4399.4097, 49.2348, 30.7523},
        BlipSetting     = {
            Ukuran      = 0.7,
            Warna       = 5,
            Jenis       = 318
        },
        ActionTarget    = {
            {
				icon 		= "fas fa-box-open",
				label 		= "Menjual Tambang",
                action      = function()
                    NzdxMenjualTambang()
                end,
                canInteract = function(entity) 
                    return GlobalState['cekDutyPenambang'] and not GlobalState['actionPenambang']
                end
            }
        }
    },
}

Nzdx.BajuPenambang   = {
    bajudinas   = {
        male    = {
            tshirt_1 = 210,
            tshirt_2 = 0,
            torso_1 = 134,
            torso_2 = 1,
            chain_1 = 0,
            chain_2 = 0,
            helmet_1 = 0,
            helmet_2 = 7,
            arms = 41,
            pants_1 = 7,
            pants_2 = 0,
            shoes_1 = 125,
            shoes_2 = 0
        },
        female   = {
            tshirt_1 = 243,
            tshirt_2 = 0,
            torso_1 = 186,
            torso_2 = 1,
            decals_1 = 0,
            decals_2 = 0,
            arms = 46,
            pants_1 = 47,
            pants_2 = 0,
            shoes_1 = 60,
            shoes_2 = 0
        }
    },
}

Nzdx.ActionKerja    = {
    ['Pengambilan_Batu'] = {
        Action = function()
            local NamaItem   = 'stone'
            local JumlahItem = 7

            TambahItem({item = NamaItem, amount = JumlahItem})
        end
    },

    ['Pencucian_Batu'] = {
        Action = function()
            local jumlah              = 0
            local RemoveItem          = 'stone'
            local JumlahItemRemove    = 7
            local AddItem             = 'washed_stone'
            local JumlahItemAdd       = 7
            
            for k , v in pairs(ESX.GetPlayerData().inventory) do
                if v.name == RemoveItem then
                    jumlah = v.count
                end
            end
            if jumlah >= JumlahItemRemove then
                TambahItem({item = AddItem, amount = JumlahItemAdd})
                HapusItem({item = RemoveItem, amount = JumlahItemRemove})
            else
                local Msg = string.format('Anda Tidak Memiliki %s Sebanyak %s)', RemoveItem, JumlahItemRemove)
                Notif(Msg)
            end
        end
    },

    ['Peleburan_Batu'] = {
        Action = function()
            local jumlah              = 0
            local RemoveItem          = 'washed_stone'
            local JumlahItemRemove    = 1
            local Chance              = 0.4 --[0.4 = 40%]
            local Diamond             = {Items = 'diamond', Jumlah = 1}
            local AddItem             = {
                {Items = 'gold', Jumlah   = 3}, 
                {Items = 'iron', Jumlah   = 6}, 
                {Items = 'copper', Jumlah = 8}
            }
            
            for k , v in pairs(ESX.GetPlayerData().inventory) do
                if v.name == RemoveItem then
                    jumlah = v.count
                end
            end

            if jumlah >= JumlahItemRemove then
                for a, b in pairs(AddItem) do
                    TambahItem({item = b.Items, amount = b.Jumlah})
                end

                if math.random(0, (Chance * 100)) > (Chance * 100) then
                    TambahItem({item = Diamond.Items, amount = Diamond.Jumlah})
                end
                
                HapusItem({item = RemoveItem, amount = JumlahItemRemove})
            else
                local Msg = string.format('Anda Tidak Memiliki %s Sebanyak %s', RemoveItem, JumlahItemRemove)
                Notif(Msg)
            end
        end
    },

    ['Penjualan_Emas'] = {
        Action = function()
            local jumlah              = 0
            local RemoveItem          = 'gold'
            local RateEmas            = 250

            for k , v in pairs(ESX.GetPlayerData().inventory) do
                if v.name == RemoveItem then
                    jumlah = v.count
                end
            end

            if jumlah >= 1 then
                local input = lib.inputDialog('Penjualan Emas', {
                    {type = 'slider', label = 'Jumlah Emas', min = 1, max = jumlah},
                })

                if not input then return end

                FreezeEntityPosition(cache.ped, true)
                TaskStartScenarioInPlace(cache.ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
                Progressbar('Menjual Emas', 750 * input[1], function()
                    ClearPedTasks(cache.ped)
                    TambahItem({item = 'money', amount = RateEmas * input[1]})
                    HapusItem({item = RemoveItem, amount = input[1]})
                end)
            else
                local Msg = string.format('Anda Tidak Memiliki %s Sebanyak %s', RemoveItem, 1)
                Notif(Msg)
            end
        end
    },

    ['Penjualan_Besi'] = {
        Action = function()
            local jumlah              = 0
            local RemoveItem          = 'iron'
            local RateBesi            = 200

            for k , v in pairs(ESX.GetPlayerData().inventory) do
                if v.name == RemoveItem then
                    jumlah = v.count
                end
            end

            if jumlah >= 1 then
                local input = lib.inputDialog('Penjualan Besi', {
                    {type = 'slider', label = 'Jumlah Besi', min = 1, max = jumlah},
                })

                if not input then return end

                FreezeEntityPosition(cache.ped, true)
                TaskStartScenarioInPlace(cache.ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
                Progressbar('Menjual Besi', 750 * input[1], function()
                    ClearPedTasks(cache.ped)
                    TambahItem({item = 'money', amount = RateBesi * input[1]})
                    HapusItem({item = RemoveItem, amount = input[1]})
                end)
            else
                local Msg = string.format('Anda Tidak Memiliki %s Sebanyak %s', RemoveItem, 1)
                Notif(Msg)
            end
        end
    },

    ['Penjualan_Tembaga'] = {
        Action = function()
            local jumlah              = 0
            local RemoveItem          = 'copper'
            local RateTemabga         = 150

            for k , v in pairs(ESX.GetPlayerData().inventory) do
                if v.name == RemoveItem then
                    jumlah = v.count
                end
            end

            if jumlah >= 1 then
                local input = lib.inputDialog('Penjualan Tembaga', {
                    {type = 'slider', label = 'Jumlah Tembaga', min = 1, max = jumlah},
                })

                if not input then return end

                FreezeEntityPosition(cache.ped, true)
                TaskStartScenarioInPlace(cache.ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
                Progressbar('Menjual Tembaga', 750 * input[1], function()
                    ClearPedTasks(cache.ped)
                    TambahItem({item = 'money', amount = RateTemabga * input[1]})
                    HapusItem({item = RemoveItem, amount = input[1]})
                end)
            else
                local Msg = string.format('Anda Tidak Memiliki %s Sebanyak %s', RemoveItem, 1)
                Notif(Msg)
            end
        end
    },

    ['Penjualan_Permata'] = {
        Action = function()
            local jumlah              = 0
            local RemoveItem          = 'diamond'
            local RatePermata          = 500

            for k , v in pairs(ESX.GetPlayerData().inventory) do
                if v.name == RemoveItem then
                    jumlah = v.count
                end
            end

            if jumlah >= 1 then
                local input = lib.inputDialog('Penjualan Permata', {
                    {type = 'slider', label = 'Jumlah Permata', min = 1, max = jumlah},
                })

                if not input then return end

                FreezeEntityPosition(cache.ped, true)
                TaskStartScenarioInPlace(cache.ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
                Progressbar('Menjual Permata', 750 * input[1], function()
                    ClearPedTasks(cache.ped)
                    TambahItem({item = 'money', amount = RatePermata * input[1]})
                    HapusItem({item = RemoveItem, amount = input[1]})
                end)
            else
                local Msg = string.format('Anda Tidak Memiliki %s Sebanyak %s', RemoveItem, 1)
                Notif(Msg)
            end
        end
    },
}

--- [Function Interaction] ---
function CPrint(data)
    print(json.encode(data, {indent = true}))
end

function Notif(msg)
    lib.notify({
        title       = 'Nzdx-Penambang',
        description = msg,
        type        = 'inform'
    })
end

function Progressbar(message, length, berhasil, gagal)
    FreezeEntityPosition(cache.ped, true)
    if  lib.progressBar({
            duration     = length,
            label        = message,
            useWhileDead = false,
            canCancel    = true,
            disable      = {
                move = true,
                car = true,
            }
        }) 
    then
        FreezeEntityPosition(cache.ped, false)
        berhasil()
    else
        FreezeEntityPosition(cache.ped, false)
        gagal()
    end
end

function TambahItem(data)
    TriggerServerEvent('Nzdx-Penambang:Add', {
        item   = data.item, 
        amount = data.amount,
    })
end

function HapusItem(data)
    TriggerServerEvent('Nzdx-Penambang:Remove', {
        item   = data.item, 
        amount = data.amount,
    })
end