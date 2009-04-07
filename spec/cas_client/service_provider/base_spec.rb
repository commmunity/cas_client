require File.dirname(__FILE__) + '/../../spec_helper'

describe CasClient::ServiceProvider::Base do

  it 'base url is specified on initialization' do
    provider = CasClient::ServiceProvider::Base.new('http://example.com')
    provider.base_url.should == URI.parse('http://example.com')
  end
  
  it 'can determines login logout validate and signup url' do
    provider = CasClient::ServiceProvider::Base.new('http://example.com:4243')

    provider.url_for(:login).should == URI.parse('http://example.com:4243/cas/login')
    provider.url_for(:logout).should == URI.parse('http://example.com:4243/cas/logout')
    provider.url_for(:signup).should == URI.parse('http://example.com:4243/identities/new')
    provider.url_for(:validate).should == URI.parse('http://example.com:4243/cas/serviceValidate')
  end
  
  it 'can add query parameters' do
    provider = CasClient::ServiceProvider::Base.new('http://example.com:4242')
    
    provider.url_for(:login, :renew => true).should == URI.parse('http://example.com:4242/cas/login?renew=true')
  end

  it 'raise an error if action is unknown' do
    lambda {
      CasClient::ServiceProvider::Base.new('http://example.com:4242').url_for(:unknown)
    }.should raise_error("Unknown action: unknown")
  end
  
  it 'can use and reset static url for some actions' do
    provider = CasClient::ServiceProvider::Base.new('http://example.com:4243')

    CasClient::ServiceProvider::Base.use_static_url_for(:validate, 'http://localhost')
    provider.url_for(:signup).should == URI.parse('http://example.com:4243/identities/new')
    provider.url_for(:validate).should == URI.parse('http://localhost/cas/serviceValidate')
    
    CasClient::ServiceProvider::Base.reset_static_url_for(:validate)
    provider.url_for(:validate).should == URI.parse('http://example.com:4243/cas/serviceValidate')
  end
  
  it 'can be used in ssl' do
    lambda {
      CasClient::ServiceProvider::Base.ssl = true
    }.should change(CasClient::ServiceProvider::Base, :ssl?).from(false).to(true)
    
    provider = CasClient::ServiceProvider::Base.new('http://example.com')
    provider.url_for(:login).to_s.should == 'https://example.com/cas/login'
    
    CasClient::ServiceProvider::Base.ssl = false
  end

end
