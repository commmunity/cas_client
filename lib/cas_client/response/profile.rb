module CasClient
  
  module Response
    
    class Profile
      
      def initialize(values)
        @values = values.with_indifferent_access
      end
      
      def value(key)
        @values[key.to_sym]
      end
      alias_method :[], :value
      
    end
    
  end
  
end