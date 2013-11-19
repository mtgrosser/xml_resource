class Shark < XmlResource::Base
  self.inflection = :dasherize
  
  has_attribute :shark_color
  has_attribute :shark_size
end