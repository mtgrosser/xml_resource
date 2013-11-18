module XmlResource
  class Base
    TRUE_VALUES = [true, 1, '1', 't', 'T', 'true', 'TRUE', 'on', 'ON'].to_set
    
    class_attribute :attributes, :collections, :objects, :root_path, :remove_namespaces
    self.attributes = {}
    self.collections = {}
    self.objects = {}
  
    class XmlResource::ParseError < Exception; end
    class XmlResource::TypeCastError < Exception; end
  
    class << self
    
      def from_xml(xml_or_string)
        xml_or_string and xml = parse(xml_or_string) or return
        attrs = {}
        self.attributes.each do |name, options|
          if xpath = attribute_xpath(name)
            node = xml.at(xpath)
            value = node ? node.inner_text : nil
            if !value.nil? && type = attribute_type(name)
              value = cast_to(type, value)
            end
            attrs[name] = value
          end
        end
        self.objects.each do |name, options|
          if xpath = object_xpath(name)
            attrs[name] = object_class(name).from_xml(xml.at(xpath))
          end
        end
        self.collections.each do |name, options|
          if xpath = collection_xpath(name)
            attrs[name] = collection_class(name).collection_from_xml(xml.at(xpath))
          end
        end
        new attrs
      end
    
      def collection_from_xml(xml_or_string)
        parse(xml_or_string).search(root).map { |element| from_xml(element) }.compact
      end
    
      def basename
        name.sub(/^.*::/, '')
      end
    
      def root
        self.root_path || "./#{self.basename.underscore}"
      end
    
      def root=(root)
        self.root_path = root
      end
    
      [:attribute, :object, :collection].each do |method_name|
        define_method "#{method_name}_names" do
          send(method_name.to_s.pluralize).keys
        end
      end
    
      protected
    
      def has_attribute(name, options = {})
        self.attributes = attributes.merge(name.to_sym => options.symbolize_keys!)
        attribute_accessor_method name
      end
    
      def has_attributes(*args)
        options = args.extract_options!
        args.each { |arg| has_attribute arg, options }
      end
    
      def has_object(name, options = {})
        self.objects = objects.merge(name.to_sym => options.symbolize_keys!)
        attr_accessor name
      end
    
      def has_collection(name, options = {})
        self.collections = collections.merge(name.to_sym => options.symbolize_keys!)
        define_method "#{name}" do
          instance_variable_get("@#{name}") or instance_variable_set("@#{name}", [])
        end
        define_method "#{name}=" do |assignment|
          instance_variable_set("@#{name}", assignment) if assignment
        end
      end

      private
    
      def attribute_accessor_method(name)
        define_method("#{name}") { self[name] }
        define_method("#{name}=") { |value| self[name] = value }
      end

      [:attribute, :object, :collection].each do |method_name|
        define_method "#{method_name}_xpath" do |name|
          options = send(method_name.to_s.pluralize)
          options[name] && options[name][:xpath] or "./#{name}"
        end
      end

      def attribute_type(name)
        attributes[name] && attributes[name][:type]
      end
    
      def object_class(name)
        if objects[name] && class_name = objects[name][:class_name]
          class_name.constantize
        else
          name.to_s.camelize.constantize
        end
      end
    
      def collection_class(name)
        if collections[name] && class_name = collections[name][:class_name]
          class_name.constantize
        else
          name.to_s.singularize.camelize.constantize
        end
      end
    
      def cast_to(type, value)  # only called for non-nil values
        case type
        when :string    then value
        when :integer   then value.to_i
        when :float     then value.to_f
        when :boolean   then cast_to_boolean(value)
        when :decimal   then BigDecimal.new(value)
        when :date      then Date.parse(value)
        when :datetime  then DateTime.parse(value)
        else
          raise XmlResource::TypeCastError, "don't know how to cast #{value.inspect} to #{type}"
        end
      end

      def cast_to_boolean(value)
        if value.is_a?(String) && value.blank?
          nil
        else
          TRUE_VALUES.include?(value)
        end
      end

      def parse(xml_or_string)
        case xml_or_string
        when Nokogiri::XML::Node, Nokogiri::XML::NodeSet then xml_or_string
        when String
          xml = Nokogiri.XML(xml_or_string)
          xml.remove_namespaces! if remove_namespaces
          xml.root
        else
          raise XmlResource::ParseError, "cannot parse #{xml_or_string.inspect}"
        end 
      end
    end
  
    def initialize(attrs = {})
      self.attributes = attrs
    end

    def valid?
      true
    end
  
    def attributes=(attrs)
      attrs.each { |name, value| send "#{name}=", value }
    end
  
    def attributes
      @attributes ||= {}.with_indifferent_access
    end
  
    def [](attr_name)
      attributes[attr_name]
    end
  
    def []=(attr_name, value)
      attributes[attr_name] = value
    end
  
  end
end