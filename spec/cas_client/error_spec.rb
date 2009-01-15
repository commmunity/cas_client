require File.dirname(__FILE__) + '/../spec_helper'

describe CasClient::Error do
  
  it 'can be created with a cause' do
    cause = IOError.new('Connection refused')
    e = CasClient::Error.new(cause)
    
    e.cause.should be(cause)
    e.message.should == 'Connection refused'
    e.url.should be_nil
  end
  
  it 'can be created with a cause and an URL' do
    cause = IOError.new('BAM!')
    e = CasClient::Error.new(cause, 'http://example.com')
    
    e.cause.should be(cause)
    e.message.should == 'BAM!'
    e.url.should == 'http://example.com'
  end
  
  it 'can be created with a CasClient::Error as cause' do
    cause = CasClient::Error.new(IOError.new('BAM!'))
    e = CasClient::Error.new(cause, 'http://example.net')
    
    e.cause.should be(cause)
    e.message.should == 'BAM!'
    e.url.should == 'http://example.net'
  end
  
  it 'can be created with a string as cause' do
    e = CasClient::Error.new('Protocol error')
    e.cause.should be_an_instance_of(StandardError)
    e.cause.message.should == 'Protocol error'
  end
  
end
