module CasClient
  
  module ServiceProvider
    
    class Base
      
      class << self
        
        def default_url
          @@default_url
        end
        
        def default_url=(url)
          @@default_url = url.is_a?(URI) ? url : URI.parse(url.to_s)
        end
        
      end
      
      self.default_url = 'http://localhost:3002'
      
      attr_reader :url
      
      def initialize(url = self.class.default_url)
        @url = (url.is_a?(URI) ? url : URI.parse(url)).freeze
      end
      
      def login_url
        build_url('/cas/login')
      end
    
      def logout_url
        build_url('/cas/logout')
      end
      
      def validate_url
        build_url('/cas/serviceValidate')
      end
      
      private
      
      def build_url(path)
        service_url = url.dup
        service_url.path = path
        service_url
      end
      
    end
  
  end
  
end