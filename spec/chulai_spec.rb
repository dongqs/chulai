require 'spec_helper'
require 'chulai'

describe Chulai::Base do
  it "return version" do
    expect(Chulai::Base.version).to eql Chulai::VERSION
  end

  describe "service status" do

    it "ok" do

      stub_request(:get, "http://wo.chulai.la/status").
        to_return(status: 200, body: '{"status": "success"', headers: {})

      response = RestClient.get "http://wo.chulai.la/status"
      expect(response).to be_an_instance_of(String)
    end
  end
end

