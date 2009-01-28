require File.dirname(__FILE__) + '/../spec_helper'

describe CasClient::Request do
  
  it 'returns login url' do
    request = CasClient::Request.new('http://example.com')
    request.login_url.should == URI.parse('http://localhost:3001/cas/login?service=http%3A%2F%2Fexample.com%3Fredirection_count%3D1')
  end
  
  it 'returns login url with renew parameter' do
    request = CasClient::Request.new('http://example.com')
    request.login_url(:renew => true).should == URI.parse('http://localhost:3001/cas/login?service=http%3A%2F%2Fexample.com%3Fredirection_count%3D1&renew=true')
  end
  
  it 'returns logout url' do
    request = CasClient::Request.new('http://example.com')
    request.logout_url.should == URI.parse('http://localhost:3001/cas/logout')
  end
  
  it 'returns logout url with a destination' do
    request = CasClient::Request.new('http://example.com')
    request.logout_url('http://example.net').should == URI.parse('http://localhost:3001/cas/logout?destination=http%3A%2F%2Fexample.net')
  end
  
  it 'increments redirection_count parameter' do
    request = CasClient::Request.new('http://example.com?bar=baz', :redirection_count => 3)
    request.login_url.should == URI.parse('http://localhost:3001/cas/login?service=http%3A%2F%2Fexample.com%3Fbar%3Dbaz%26redirection_count%3D4')
  end
  
  it 'must have a valid service url' do
    lambda {
      CasClient::Request.new('http://')
    }.should raise_error(CasClient::Error)
  end
  
  it 'raise if redirection_count is greater than 5' do
    lambda {
      CasClient::Request.new('http://example.com', :redirection_count => 5)
    }.should_not raise_error
    
    lambda {
      CasClient::Request.new('http://example.com', :redirection_count => 6)
    }.should raise_error(CasClient::Error, 'Max redirections: 5')
  end
  
  it 'use ticket request parameter' do
    CasClient::Request.new('http://example.com', :bar => 'foo').should_not be_validable
    CasClient::Request.new('http://example.com', :ticket => 'foo').should be_validable
  end
  
end
