require File.dirname(__FILE__) + '/../../spec_helper'

describe CasClient::Response::Valid do
  
  it 'raise an error if document is invalid' do
    lambda {
      CasClient::Response::Valid.new(Nokogiri::XML(%q{
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
    response = CasClient::Response::Valid.new(Nokogiri::XML(%q{
      <?xml version="1.0" encoding="UTF-8"?>
      <cas:serviceResponse xmlns:cas='http://www.yale.edu/tp/cas'>
          <cas:authenticationSuccess>
              <cas:user>john@example.com</cas:user>
          </cas:authenticationSuccess>
      </cas:serviceResponse>
    }))
    
    response.profile['user'].should == 'john@example.com'
  end
  
end
