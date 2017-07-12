class RbkRate
  class << self
    def update_rate
      response = RestClient.get('http://www.rbc.ru/ajax/indicators?_=1499870537749')

      JSON.parse(response)['currency'].each do |rate|

        attributes = { remote_id: rate['id'],
                          name: rate['name'],
                          subname: rate['subname'],
                          chg_abs: rate['chg_abs'],
                          value1: rate['value1'] }

        indicator = Indicator.find_by_remote_id(rate['id'])

        if indicator.nil?
          Indicator.create( attributes )
        else
          indicator.auto_update( attributes )
        end
      end
    end
  end
end
