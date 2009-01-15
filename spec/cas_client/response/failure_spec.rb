require File.dirname(__FILE__) + '/../../spec_helper'

describe CasClient::Response::Failure do
  
  it 'it parses code and error' do
    response = CasClient::Response::Failure.new(Nokogiri::XML(%q{
      <?xml version="1.0" encoding="UTF-8"?>
      <cas:serviceResponse xmlns:cas="http://www.yale.edu/tp/cas">
          <cas:authenticationFailure code="INVALID_TICKET">
              BAM!
          </cas:authenticationFailure>
      </cas:serviceResponse>
    }))
    
    response.code.should == 'INVALID_TICKET'
    response.error.should == 'BAM!'
  end
  
  it 'raise an error if document is invalid' do
    lambda {
      CasClient::Response::Failure.new(Nokogiri::XML(%q{
        <?xml version="1.0" encoding="UTF-8"?>
        <cas:serviceResponse xmlns:cas="http://www.yale.edu/tp/cas">
            <cas:authenticationFailed code="INVALID_TICKET">
                BAM!
            </cas:authenticationFailed>
        </cas:serviceResponse>
      }))
    }.should raise_error(CasClient::Error, "Can't parse document")
  end
  
end
