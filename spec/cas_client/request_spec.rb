require File.dirname(__FILE__) + '/../spec_helper'

describe CasClient::Request do
  
  it 'returns login url' do
    request = CasClient::Request.new('http://example.com')
    request.login_url.should == URI.parse('http://localhost:3001/cas/login?service=http%3A%2F%2Fexample.com')
  end
  
  it 'returns logout url' do
    request = CasClient::Request.new('http://example.com')
    request.logout_url.should == URI.parse('http://localhost:3001/cas/logout')
  end
  
  it 'use ticket request parameter' do
    CasClient::Request.new('http://example.com', 'bar' => 'foo').ticket?.should be_false
    CasClient::Request.new('http://example.com', 'ticket' => 'foo').ticket?.should be_true
  end
  
end
