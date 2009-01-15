module CasClient
  
  class Error < StandardError
    
    attr_reader :cause
    attr_reader :url

    def initialize(cause, url = nil)
      @cause = cause.is_a?(Exception) ? cause : StandardError.new(cause.to_s)
      super(@cause.message)
      @url = url
      @url ||= @cause.url if @cause.is_a?(CasClient::Error)
    end
   
  end
  
end