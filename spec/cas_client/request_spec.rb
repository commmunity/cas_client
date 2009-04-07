require File.dirname(__FILE__) + '/../spec_helper'

describe CasClient::Request do
  
  it 'returns login url from service provider' do
    request = CasClient::Request.new('http://example.com')
    request.login_url.should == URI.parse('http://localhost:3002/cas/login?service=http%3A%2F%2Fexample.com')
  end
  
  it 'returns login url with parameters' do
    request = CasClient::Request.new('http://example.com')
    url = request.login_url(:auth => 'autologin', :renew => true, :type => 'acceptor').to_s
    
    url.should match(/service=http%3A%2F%2Fexample.com/)
    url.should match(/type=acceptor/)
    url.should match(/renew=true/)
    url.should match(/type=acceptor/)
  end
  
  it 'returns login url with service url overridden' do
    request = CasClient::Request.new('http://example.com')
    request.login_url(:service => 'http://service.net').should == URI.parse('http://localhost:3002/cas/login?service=http%3A%2F%2Fservice.net')
  end
  
  it 'returns logout url' do
    request = CasClient::Request.new('http://example.com')
    request.logout_url.should == URI.parse('http://localhost:3002/cas/logout')
  end
  
  it 'returns signup url' do
    request = CasClient::Request.new('http://example.com')
    request.signup_url.should == URI.parse('http://localhost:3002/identities/new?service=http%3A%2F%2Fexample.com')
  end
  
  it 'returns logout url with a destination' do
    request = CasClient::Request.new('http://example.com')
    request.logout_url(:destination => 'http://example.net').should == URI.parse('http://localhost:3002/cas/logout?destination=http%3A%2F%2Fexample.net')
  end
  
  it 'must have a valid service url' do
    lambda {
      CasClient::Request.new('http://')
    }.should raise_error(CasClient::Error)
  end
  
  it 'is validable if ticket parameter is present' do
    CasClient::Request.should_not be_validable(:bar => 'foo')
    CasClient::Request.should_not be_validable(:ticket => 'foo')
  end
  
  it 'removes fragment on service url' do
    CasClient::Request.new('http://example.com?tata=bar&ticket=titi#toto').service_url.should == URI.parse('http://example.com?tata=bar')
    CasClient::Request.new('http://example.com?ticket=bam&bar=foo').service_url.should == URI.parse('http://example.com?bar=foo')
    CasClient::Request.new('http://example.com?ticket=bam').service_url.should == URI.parse('http://example.com')
  end
  
end
