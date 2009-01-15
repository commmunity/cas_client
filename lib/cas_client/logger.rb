module CasClient
  
  module Logger
    
    class SilentLogger
      
      def debug(*args)
      end
      
    end
    
    mattr_accessor :logger
    @@logger = CasClient::Logger::SilentLogger.new
    
  end
  
end