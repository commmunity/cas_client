require File.dirname(__FILE__) + '/../../spec_helper'

describe CasClient::Response::Profile do
  
  it 'has values' do
    profile = CasClient::Response::Profile.new(:user => 'john', 'avatar_url' => 'http://example.com/image.jpg')
    profile['user'].should == 'john'
    profile[:avatar_url].should == 'http://example.com/image.jpg'
  end
  
end
