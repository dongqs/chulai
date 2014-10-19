module Chulai

  class Base

    attr_reader :identity, :token

    API_BASE_URL = "http://wo.chulai.la"
    GIT_ROOT = "git.chulai.la"
    SSH_KEY = "chulai"
    SUFFIX = "chulai.la"

    def initialize root = '.'
      @root = root
    rescue => e
      puts "Error: #{e.inspect}"
      exit
    end

    def account
      if Git.global_config.keys.include? 'chulai.token'
        account_check
      else
        account_sign_in
      end
    end

    def auth_token
      if @auth_token
        @auth_token
      else
        account
      end
      @auth_token
    end

    def git
      return @git if @git
      @git = Git.open @root#, log: Logger.new(STDOUT)
      unless @git.log.first.to_s == @git.branches[:master].gcommit.log.first.to_s
        puts "Error: please checkout to master branch first"
        exit
      end
      @git
    rescue => e
      puts "Error: git not initailzed"
      exit
    end

    def account_check
      puts "checking account"
      @auth_token = Git.global_config 'chulai.token'
      res = http_without_auth :post, "/account_check.json", auth_token: @auth_token
      @username = res["username"]
      if res["status"] == 'success'
        [@username, @auth_token]
      else
        puts "error: #{res["message"]}"
        exit
      end
    end

    def account_sign_in
      puts "please sign in"
      print "email: "
      email = $stdin.gets.chomp
      print "password: "
      password = STDIN.noecho(&:gets).chomp
      puts

      res = http_without_auth :post, "/account_sign_in.json", user: {
        email: email,
        password: password
      }
      if res["status"] == 'success'
        @username = res["username"]
        @auth_token = res["auth_token"]
        Git.global_config 'chulai.token', @auth_token
      else
        puts "error: #{res["message"]}"
      end
    end

    def ssh_key
      puts "checking ssh key"
      key_dir = File.expand_path "~/.ssh"
      Dir.mkdir key_dir unless Dir.exist? key_dir
      key_path = File.join key_dir, SSH_KEY
      key = SSHKey.new File.read key_path
    rescue => e
      puts "sshkey ~/.ssh/chulai not found, generate a new one"
      key = SSHKey.generate
      File.open(key_path, "w") do |f|
        f.write key.private_key
        f.chmod 0400
      end
      File.open("#{key_path}.pub", "w") do |f|
        f.write key.ssh_public_key
      end
      res = http :post, "/keys.json", key: {name: Socket.gethostname, content: key.ssh_public_key}
    end

    def ssh_config
      puts "checking ssh config"
      config_dir = File.expand_path "~/.ssh"
      Dir.mkdir config_dir unless Dir.exist? config_dir

      config_path = File.join config_dir, "config"
      unless File.exist?(config_path) and Net::SSH::Config.load(config_path, SSH_KEY).length > 1
        File.open config_path, "a" do |f|
          f.write [
            "",
            "Host #{SSH_KEY}",
            "HostName #{GIT_ROOT}",
            "User git",
            "IdentityFile ~/.ssh/#{SSH_KEY}",
            "",
          ].join("\n")
        end
      end
    end

    def gemfile
      puts "checking Gemfile"
      unless File.exist? 'Gemfile'
        puts "Error: Gemfile not found, please make sure you are in a Rails project dir"
        exit
      end
      @gemfile = Gemnasium::Parser::Gemfile.new File.read("Gemfile")
      gems = @gemfile.dependencies.map(&:name)
      unless gems.include? 'rails'
        puts "Error: chulai ONLY support Rails projects by now"
        exit
      end
      requires = ['puma', 'mysql2', 'therubyracer']
      missing = []
      requires.each do |gem|
        missing << gem unless gems.include? gem
      end
      unless missing.empty?
        puts <<-EOF
Er  ror: those gems are required, add them to Gemfile
#{  missing.map {|gem|"  gem '#{gem}'"}.join("\n")}
        EOF
        exit
      end
    end

    def push
      puts "pushing to git server"

      remote = git.remote(:chulai)
      if remote.url.nil?
        res = http :post, "/birth.json"

        raise res.inspect unless res['status'] == 'success'
        @identity, @name = res["identity"], res["name"]
        git.add_remote :chulai, "#{SSH_KEY}:#{@identity}.git"
        git.config 'chulai.identity', @identity
        git.config 'chulai.name', @name
      else
        @identity = git.config 'chulai.identity'

        res = http :post, "/check.json", identity: @identity

        raise res.inspect unless res && res['status'] == 'success'
        @name = res["name"]
      end
      git.push(git.remote("chulai"))
    end

    def deploy
      puts "deploying"

      stream :post, "/deploy.stream", identity: identity, commit: git.log.first.sha , comment: git.log.first.message do |chunk|
        puts chunk
      end
    end

    def clean
      puts "cleaning"
      res = http :post, "/clean.json", identity: @identity
      puts res.inspect
    end

    def open
      Launchy.open "http://#{@username}.#{@name}.#{SUFFIX}"
    end

    private


    METHODS = [:get, :post, :put, :patch, :delete]

    def http_without_auth method, path, body = {}
      raise "method #{method} not allowed" unless METHODS.include? method

#      # for debug
#      return {"status" => "success"}

      url = "#{API_BASE_URL}#{path}"
      res = RestClient.send method, url, body.to_json, content_type: :json
      JSON.parse res
    rescue => exc
      puts "failed to #{method} #{url}\n#{exc.inspect}\nbody: #{body}\nresponse: #{res}\n"
      exit
    end

    def http method, path, body = {}
      http_without_auth method, path, body.merge({auth_token: auth_token})
    end

    def fake_stream method, path, body = {}
      puts "*"*50 + "fake stream"
      [method, "#{API_BASE_URL}#{path}", body].each do |chunk|
        yield chunk
      end
      puts "*"*50
    end

    def req_factory method, uri
      method = method.to_s
      method[0] = method[0].upcase
      eval("Net::HTTP::#{method}.new uri")
    end

    def stream method, path, body = {}
      raise "method #{method} not allowed" unless METHODS.include? method

#      # for debug
#      return fake_stream method, path, body do |chunk|
#        yield chunk
#      end

      uri = URI "#{API_BASE_URL}#{path}"
      Net::HTTP.start(uri.host, uri.port, read_timeout: 150) do |http|
        req = req_factory method, uri
        req.body = body.merge({auth_token: auth_token}).to_json
        req.content_type = "application/json"
        http.request req do |res|
          res.read_body do |chunk|
            yield chunk
          end
        end
      end
    end
  end
end
