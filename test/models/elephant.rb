class Elephant < XmlResource::Base
  self.inflection = :upcase
  
  has_attribute :color
end