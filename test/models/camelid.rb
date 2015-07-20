class Camelid
  include XmlResource::Model
  
  has_attribute :humps, type: :integer
end