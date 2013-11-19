class Camel < Camelid
  self.inflection = :lower_camelcase

  has_attribute :camel_color
  has_attribute :camel_price
end