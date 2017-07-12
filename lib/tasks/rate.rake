namespace :rate do
  desc 'Забираем курсы с главной страници RBK'
  task rbk: :environment do
    RbkRate.update_rate
  end

  desc 'Бесконечно забираем курсы с главной страници RBK с интервалом в 5 секунд'
  task rbk_every_5_seconds: :environment do
    while true do
      RbkRate.update_rate
      sleep(5)
    end
  end
end
