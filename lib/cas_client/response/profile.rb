module CasClient
  
  module Response
    
    class Profile
      
      include Enumerable
      
      def initialize(attributes)
        @attributes = attributes.with_indifferent_access
      end
      
      def attributes(*keys)
        returning({}.with_indifferent_access) do |attributes|
          keys.each do |key|
            value = @attributes[key]
            attributes[key] = value unless value.nil?
          end
        end
      end
      
      def each(&block)
        @attributes.each(&block)
      end
      
      def value(key)
        @attributes[key.to_sym]
      end
      alias_method :[], :value
      
    end
    
  end
  
end