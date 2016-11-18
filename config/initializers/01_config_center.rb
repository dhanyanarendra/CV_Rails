module ConfigCenter
  module Default

    def self.host
      case Rails.env
      when "development"
        'http://localhost:3000'
      when "it"
        'http://it-peershape-election-api.qwinix.io'
      when "st"
        'http://st-peershape-election-api.qwinix.io'
      when "uat"
        'http://uat-peershape-election-api.qwinix.io'
      when "production"
        'http://api.peershape.com'
      end
    end


    def self.fog_directory
      case Rails.env
      when "development"
        'peershape-it'
      when "it"
        'peershape-it'
      when "st"
        'peershape-st'
      when "uat"
        'peershape-uat'
      when "production"
        'peershape-prod'
      end
    end
  end
end
