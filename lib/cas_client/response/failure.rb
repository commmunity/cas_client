module CasClient
  
  module Response
    
    class Failure < Base
      
      include CasClient::Logger

      attr_reader :code
      attr_reader :error
      
      def initialize(document)
        super(document)
        logger.debug('[CAS] Response is failure')
        @node = self.document.xpath("//*[name() = 'cas:authenticationFailure']").first
        raise CasClient::Error.new("Can't parse document") unless @node
        @code = fetch_code
        @error = fetch_error
      end
      
      private
      
      def fetch_code
        @node.attributes['code'].value.strip
      end
      
      def fetch_error
        @node.text.strip
      end
      
    end
    
  end
  
end