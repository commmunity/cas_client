module CasClient
  
  module ServiceProvider
    
    class Base
      
      ACTION_MAPPING = {
        :login => '/cas/login',
        :logout => '/cas/logout',
        :signup => '/identities/new',
        :validate => '/cas/serviceValidate',
      } unless const_defined?(:ACTION_MAPPING)
      
      class << self
        
        @@static_urls = {}
        @@ssl = false
        
        def use_static_url_for(action, url)
          raise "Unknown action: #{action}" unless ACTION_MAPPING.key?(action.to_sym)
          @@static_urls[action] = (url.is_a?(URI::HTTP) ? url : URI.parse(url)).freeze
        end
        
        def reset_static_url_for(action)
          @@static_urls.delete(action.to_sym)
        end
        
        def ssl=(value)
          @@ssl = value
        end
        
        def ssl?
          @@ssl
        end
        
      end
            
      attr_reader :base_url
      
      def initialize(base_url = 'http://localhost:3002')
        @base_url = (base_url.is_a?(URI::HTTP) ? base_url : URI.parse(base_url)).freeze
      end
      
      def url_for(action, params = {})
        path = ACTION_MAPPING[action.to_sym] || raise("Unknown action: #{action}")
        url = (@@static_urls[action.to_sym] || base_url).dup
        
        # ssl?
        url.scheme = 'https' if self.class.ssl?
        
        # path
        url.path = path
        
        # query
        query = params.map do |name, value|
          next if value.nil?
          "#{name}=#{CGI.escape(value.to_s)}"
        end.join('&')
        url.query = query if query.present?
        
        url
      end
      
    end
  
  end
  
end