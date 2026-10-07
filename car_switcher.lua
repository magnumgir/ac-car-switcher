-- MotorsportRR Quick Car Switcher
-- CSP online server script. Reconnects to the current server with another car.

local cars = {
  { name = 'Renault Clio 4 GT Line', id = 'acdz_clio_4_gt_line' },
  { name = 'Dacia Stepway', id = 'acdz_ramy_dacia_stepway' },
  { name = 'VW Golf 7.5 R', id = 'acdz_ramy_vw_golf_75r' },
  { name = 'VW Golf R 2022', id = 'acdz_ramy_golf_r_2022' },
  { name = 'VW Polo 2018', id = 'acdz_ramy_polo_2018' },
  { name = 'Audi S3', id = 'acdz_ramy_audi_s3' },
  { name = 'VW Golf 6 R20', id = 'acdz_ramy_vw_golf_6_r20' },
  { name = 'Mercedes-AMG A45 S', id = 'acdz_ramy_mercedes_a45s' },
  { name = 'SEAT Ibiza', id = 'acdz_ramy_seat_ibiza' },
  { name = 'VW Polo 1.6 TDI', id = 'acdz_ramy_polo_1.6_tdi' },
  { name = 'Cupra 2015 V2', id = 'acdz_ramy_cupra_2015_v2' },
  { name = 'Renault Clio RS Line', id = 'ramy_clio_rsline' },
  { name = 'Peugeot 208 2023', id = 'ramy_peugeot_208_2023' },
  { name = 'Skoda Octavia 2019', id = 'ramy_skoda_octavia_2019' },
  { name = 'VW Tiguan R-Line', id = 'ramy_volkswagen_tiguan_rline' },
  { name = 'Fiat Tipo Life', id = 'ramy_fiat_tipo_life' },
  { name = 'MG5 2025', id = 'ramy_mg5_2025' },
  { name = 'VW Tharu XR', id = 'ramy_vw_tharu_xr' },
  { name = 'Kia Rio 2019', id = 'ramy_kia_rio_2019' },
}

local selected = 1
local showSwitcher = false
local confirmUntil = 0

local function currentCarID()
  local c = ac.getCar(0)
  return c and c.id or ''
end

local function switchCar(item)
  if not item then return end
  ac.reconnectTo({ carID = item.id })
end

function script.drawUI()
  -- Small toggle button in the upper-left. Keeps the full list out of the way while driving.
  ui.setCursor(vec2(18, 110))
  if ui.button(showSwitcher and 'Close car switcher' or 'Change car') then
    showSwitcher = not showSwitcher
  end

  if not showSwitcher then return end

  ui.setCursor(vec2(18, 148))
  ui.childWindow('##motorsportrr_car_switcher', vec2(390, 530), true, ui.WindowFlags.AlwaysAutoResize, function()
    ui.text('MOTORSPORTRR - QUICK CAR SWITCH')
    ui.separator()
    ui.textWrapped('Select a car. CSP will reconnect you to this same server using that car; the game itself stays open.')
    ui.separator()

    local current = currentCarID()
    for i, item in ipairs(cars) do
      local label = item.name
      if item.id == current then label = label .. '  [CURRENT]' end
      if ui.selectable(label .. '##' .. item.id, selected == i) then
        selected = i
        confirmUntil = 0
      end
    end

    ui.separator()
    local item = cars[selected]
    if item then
      ui.text('Selected: ' .. item.name)
      if item.id == current then
        ui.textDisabled('You are already using this car.')
      else
        local now = os.preciseClock()
        if confirmUntil > now then
          if ui.button('CONFIRM SWITCH TO ' .. item.name, vec2(-1, 42)) then
            switchCar(item)
          end
          ui.textDisabled('This will reconnect to the same server.')
        else
          if ui.button('SWITCH CAR', vec2(-1, 42)) then
            confirmUntil = now + 5
          end
        end
      end
    end
  end)
end
