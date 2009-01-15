require File.dirname(__FILE__) + '/../../spec_helper'

describe CasClient::Response::Success do
  
  it 'raise an error if document is invalid' do
    lambda {
      CasClient::Response::Success.new(Nokogiri::XML(%q{
        <?xml version="1.0" encoding="UTF-8"?>
        <cas:serviceResponse xmlns:cas="http://www.yale.edu/tp/cas">
            <cas:authenticationFailure code="INVALID_TICKET">
                BAM!
            </cas:authenticationFailure>
        </cas:serviceResponse>
      }))
    }.should raise_error(CasClient::Error, "Can't parse document")
  end
  
  it "it retrieve user's profile" do
    response = CasClient::Response::Success.new(Nokogiri::XML(%q{
      <?xml version="1.0" encoding="UTF-8"?>
      <cas:serviceResponse xmlns:cas='http://www.yale.edu/tp/cas'>
          <cas:authenticationSuccess>
              <cas:user>john@example.com</cas:user>
              <sc:profile xmlns:sc='http://slashcommunity.com/sc'>
                  <email>john@example.com</email>
                  <firstname>john</firstname>
                  <lastname>doe</lastname>
              </sc:profile>
          </cas:authenticationSuccess>
      </cas:serviceResponse>
    }))
    
    response.profile[:email].should == 'john@example.com'
    response.profile[:firstname].should == 'john'
    response.profile[:lastname].should == 'doe'
  end
  
end
