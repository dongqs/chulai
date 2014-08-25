require 'webmock/rspec'

WebMock.disable_net_connect! allow_localhost: true

RSpec.configure do |config|

  config.before(:each) do

    stub_request(:get, "http://wo.chulai.la/status").
      to_return(status: 200, body: '{"status": "success"', headers: {})
  end
end
