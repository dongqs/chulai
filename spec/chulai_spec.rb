require 'spec_helper'
require 'chulai'

describe Chulai::Base do
  it "return version" do
    expect(Chulai::Base.new.version).to eql Chulai::VERSION
  end

  describe "service status" do

    it "ok" do

      stub_request(:post, "http://wo.chulai.la/status").
        to_return(status: 200, body: '{"status": "success"}', headers: {})

      res = Chulai::Base.new.status
      expect(res).to be_an_instance_of(String)
    end

    it "not ok" do

      stub_request(:post, "http://wo.chulai.la/status").
        to_return(status: 500, body: '{"status": "error", "message": "service under maintainess"}', headers: {})

      expect {
        Chulai::Base.new.status
      }.to raise_error
    end
  end

  describe "check user auth_token" do

    it "get auth_token" do

      Git = double "Git", global_config: {"chulai.auth_token" => "ooxx", "chulai.username" => "aya"}

      base = Chulai::Base.new
      base.load_user_info
      expect(base.auth_token).to eql "ooxx"
      expect(base.username).to eql "aya"
      expect(base.load_user_info).not_to be_nil
    end

    it "failed to get auth_token" do

      Git = double "Git", global_config: {}

      base = Chulai::Base.new
      expect(base.load_user_info).to be_nil
    end
  end
end

