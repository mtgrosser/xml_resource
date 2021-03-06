class Order
  include XmlResource::Model
  
  has_attribute :id, :type => :integer
  has_attribute :date, :type => :date, :xpath => 'info/date'
  has_attribute :foobar, :xpath => 'info/foo[@type="bar"]'
  has_attribute :finished, :type => :boolean
  has_attribute :shipping_cost, :type => :decimal
  has_attribute :created_at, type: :time, xpath: 'info/created_at'
  
  has_object :customer, :class_name => "Contact"
  has_object :contact
  
  has_collection :items, :class_name => "Item", :xpath => 'items'
end
