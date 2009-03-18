require File.dirname(__FILE__) + '/../../spec_helper'

describe CasClient::Response::Profile do 
  it 'has values' do
    profile = CasClient::Response::Profile.new(:firstname => 'john', 'avatar_url' => 'http://example.com/image.jpg')
    profile.should_not be_empty
    profile['firstname'].should == 'john'
    profile.value(:avatar_url).should == 'http://example.com/image.jpg'
  end
  
  it 'can retrieve attributes' do
    profile = CasClient::Response::Profile.new(:firstname => 'john', 'lastname' => 'doe', 'avatar_url' => 'http://example.com/image.jpg')
    attributes = profile.attributes
    attributes[:firstname].should == 'john'
    attributes['lastname'].should == 'doe'
  end
  
  it 'is enumerable' do
    profile = CasClient::Response::Profile.new(:firstname => 'john', 'lastname' => 'doe', 'avatar_url' => 'http://example.com/image.jpg')
    profile.should_receive(:value).exactly(3).times
    profile.each do |key, value|
      profile.value(key)
    end
  end
  
  it 'grab role_label from params "role"' do
     profile = CasClient::Response::Profile.new(:firstname => 'john', 'lastname' => 'doe', 'avatar_url' => 'http://example.com/image.jpg', 'role' => 'admin')
     profile.role_label.should == 'admin'
  end
end