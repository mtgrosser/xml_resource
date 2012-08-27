class Contact < XmlResource::Base
  has_attributes :first_name, :last_name, :type => :string
  
  def name
    "#{first_name} #{last_name}"
  end
end