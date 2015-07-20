class Elephant
  include XmlResource::Model
  
  self.inflection = :upcase
  
  has_attribute :color
end