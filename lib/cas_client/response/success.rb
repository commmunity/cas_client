module CasClient
  
  module Response
    
    class Success < Base
      
      include CasClient::Logger
      
      attr_reader :profile
      
      def initialize(document)
        super(document)
        logger.debug('[CAS] Response is success')
        @profile = fetch_profile
      end
      
      private
      
      def fetch_profile
        node = self.document.xpath("//*[name() = 'cas:authenticationSuccess']//*[name() = 'sc:profile']").first
        raise CasClient::Error.new("Can't parse document") unless node
        Profile.new(xml_to_hash(node))
      end
      
      def xml_to_hash(xml)
        hash = Hash.from_xml(xml.to_s)['profile']
        return {} unless hash.is_a?(Hash)
        hash.delete('xmlns:sc')
        hash
      rescue => e
        logger.debug(e.message)
        {}
      end
      
    end
    
  end
  
end