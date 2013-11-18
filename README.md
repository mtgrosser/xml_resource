xml_resource
============

Turn XML into Ruby objects

```ruby
xml = %q{
<library>
  <books>
    <book>
      <name>The Tempest</name>
      <author>William Shakespeare</author>
      <firstpublished>Nov 1, 1611</firstpublished>
    </book>
    <book>
      <name>Moby-Dick</name>
      <author>Herman Melville</author>
      <firstpublished>Oct 18, 1851</firstpublished>
    </book>
  </books>
  <hours>
    <from>08:00 AM</from>
    <till>06:00 PM</till>
  </hours>
</library>
}

class Library < XmlResource::Base
  has_collection :books

  has_attribute :open_from, :xpath => 'hours/from'
  has_attribute :open_till, :xpath => 'hours/till'
end

class Book < XmlResource::Base
  has_attribute :name
  has_attribute :author
  has_attribute :published, :type => :date, :xpath => 'firstpublished'
end

library = Library.from_xml(xml)
=> #<Library:0x00000100dcf7e8 @attributes={"open_from"=>"08:00 AM", "open_till"=>"06:00 PM"}, @books=[#<Book:0x00000100dd1778 @attributes={"name"=>"The Tempest", "author"=>"William Shakespeare", "published"=>Tue, 01 Nov 1611}>, #<Book:0x00000100dcfbd0 @attributes={"name"=>"Moby-Dick", "author"=>"Herman Melville", "published"=>Sat, 18 Oct 1851}>]>

library.open_from
=> "08:00 AM"

book = library.books.first
=> #<Book:0x00000100dd1778 @attributes={"name"=>"The Tempest", "author"=>"William Shakespeare", "published"=>Tue, 01 Nov 1611}>

book.published
=> Tue, 01 Nov 1611
```
