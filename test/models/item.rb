class Item
  include XmlResource::Model
  
  self.root = 'i'
  
  has_attribute :quantity, :type => :float
  has_attribute :name
end