module Chulai

  class Base

    def version

      VERSION
    end

    def status

      http "#{BASE_URL}/status"
    end

    def http path, body = {}
      res = RestClient.post "#{BASE_URL}/status", body.to_json
      status = JSON.parse(res)["status"]
    rescue => exc
      raise status || exc
    end
  end
end
