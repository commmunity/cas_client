require File.dirname(__FILE__) + '/../../spec_helper'

describe CasClient::ServiceProvider::Base do

  it 'has a default url to http://localhost:3002' do
    CasClient::ServiceProvider::Base.default_url.should == URI.parse('http://localhost:3002')
  end
  
  it 'default url can be modified' do
    CasClient::ServiceProvider::Base.default_url = 'http://example.com:4242'
    CasClient::ServiceProvider::Base.default_url.should == URI.parse('http://example.com:4242')
    CasClient::ServiceProvider::Base.default_url = 'http://localhost:3002'
  end
  
  it 'url can be specified on initialization' do
    provider = CasClient::ServiceProvider::Base.new('http://example.com')
    provider.url.should == URI.parse('http://example.com')
  end
  
  it 'can determines login logout and validate url' do
    provider = CasClient::ServiceProvider::Base.new('http://example.com:4243')
    
    provider.login_url.should == URI.parse('http://example.com:4243/cas/login')
    provider.logout_url.should == URI.parse('http://example.com:4243/cas/logout')
    provider.validate_url.should == URI.parse('http://example.com:4243/cas/serviceValidate')
  end

end
