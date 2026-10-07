-- MotorsportRR car switch test

function script.drawUI()
  ui.text('MOTORSPORTRR CAR SWITCH TEST')

  if ui.button('SWITCH TO GOLF 7.5 R') then
    ac.reconnectTo({
      carID = 'acdz_ramy_vw_golf_75r'
    })
  end
end
