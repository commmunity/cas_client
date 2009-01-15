module CasClient
  
  module Response
    
    class Valid < Base
      
      attr_reader :profile
      
      def initialize(document)
        super(document)
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
        hash.delete('xmlns:sc')
        hash
      end
      
    end
    
  end
  
end