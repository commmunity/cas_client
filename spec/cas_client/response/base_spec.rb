require File.dirname(__FILE__) + '/../../spec_helper'

describe CasClient::Response::Base do
  
  it 'parses a success response body' do
    response = CasClient::Response::Base.parse(%q{
      <?xml version="1.0" encoding="UTF-8"?>
      <cas:serviceResponse xmlns:cas="http://www.yale.edu/tp/cas">
          <cas:authenticationSuccess> 
              <cas:user>username</cas:user> 
              <sc:profile xmlns:sc='http://slashcommunity.com/sc'>
                  <email>john@example.com</email>
                  <firstname>john</firstname>
                  <lastname>doe</lastname>
              </sc:profile>
          </cas:authenticationSuccess>
      </cas:serviceResponse>
    })
    
    response.should be_an_instance_of(CasClient::Response::Success)
  end
  
  it 'parses an invalid response body' do
    response = CasClient::Response::Base.parse(%q{
      <?xml version="1.0" encoding="UTF-8"?>
      <cas:serviceResponse xmlns:cas="http://www.yale.edu/tp/cas">
          <cas:authenticationFailure code="INVALID_TICKET">
              BAM!
          </cas:authenticationFailure>
      </cas:serviceResponse>
    })
    
    response.should be_an_instance_of(CasClient::Response::Failure)
  end
  
  it 'parses an unknown response body' do
    lambda {
      CasClient::Response::Base.parse(%q{
        <?xml version="1.0" encoding="UTF-8"?>
        <cas:serviceResponse xmlns:cas="http://www.yale.edu/tp/cas">
            <cas:authenticationFailed code="INVALID_TICKET">
                BAM!
            </cas:authenticationFailure>
        </cas:serviceResponse>
      })
    }.should raise_error(CasClient::Error, "Can't parse response body")
  end
  
  it 'parse an invalid xml response body' do
    lambda {
      CasClient::Response::Base.parse('BAM!')
    }.should raise_error(CasClient::Error, "Can't parse response body")
  end
  
end
