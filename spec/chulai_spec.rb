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
end

