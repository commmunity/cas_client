module CasClient
  
  module Response
    
    class Valid < Base
      
      attr_reader :profile
      
      def initialize(document)
        super(document)
        @node = self.document.xpath("//*[name() = 'cas:authenticationSuccess']").first
        raise CasClient::Error.new("Can't parse document") unless @node
        @profile = fetch_profile
      end
      
      private
      
      def fetch_profile
        Profile.new(
          :user => @node.xpath("//*[name() = 'cas:user']").first.text
        )
      end
      
    end
    
  end
  
end