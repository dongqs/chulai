require 'chulai'

describe Chulai::Base do
  it "return version" do
    expect(Chulai::Base.version).to eql Chulai::VERSION
  end
end
