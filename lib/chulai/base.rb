module Chulai

  class Base

    attr :auth_token, :username

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

    def load_user_info
      @auth_token = Git.global_config["chulai.auth_token"]
      @username = Git.global_config["chulai.username"]
      @auth_token && @username
    end
  end
end
