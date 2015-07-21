class Gadget
  include XmlResource::Model  
  
  attr_reader :name
  
  has_attribute :magic
  
  def initialize(name, attrs = {})
    raise ArgumentError, 'Name is required' if name.blank?
    @name = name
    super(attrs)
  end
end