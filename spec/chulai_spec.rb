require 'spec_helper'
require 'chulai'

describe Chulai::Base do
  it "return version" do
    expect(Chulai::Base.version).to eql Chulai::VERSION
  end

  it "service status" do
    response = RestClient.get "http://wo.chulai.la/status"

    expect(response).to be_an_instance_of(String)
  end
end

