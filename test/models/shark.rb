class Shark
  include XmlResource::Model
    
  self.inflection = :dasherize
  
  has_attribute :shark_color
  has_attribute :shark_size
end