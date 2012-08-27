# encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

require 'xml_resource'

class XmlResourceTest < ActiveSupport::TestCase

  setup do
    xml = File.read(File.expand_path(File.dirname(__FILE__) + '/../data/orders.xml'))
    @orders = Order.collection_from_xml(xml)
  end    
  
  test 'Instantiation of attributes' do
    assert_equal 3, orders.size
    assert_equal [1, 2, 3], orders.map(&:id)
    assert_equal %w(A B C), orders.map(&:foobar)
    assert_equal %w(2012-08-27 2012-08-26 2012-08-25).map(&:to_date), orders.map(&:date)
    assert_equal [12.99, 10, -12.99], orders.map(&:shipping_cost)
    assert_equal [BigDecimal], orders.map(&:shipping_cost).map(&:class).uniq
    assert_equal [:quantity, :name], Item.attribute_names
  end
  
  test 'Instantiation of objects' do
    assert_equal "Mister Spock", orders.first.customer.name
    assert_equal "Käptn Kirk", orders.second.customer.name
    assert_equal nil, orders.third.customer
    assert_equal ['E F', 'A B', 'C D'], orders.map(&:contact).map(&:name)
  end
  
  test 'Instantiation of collections' do
    items = orders.map(&:items)
    assert_equal [1, 2, 3], items.map(&:size)
    assert_equal [[3], [3, 2], [3, 2, 1]], items.map { |ary| ary.map(&:quantity) }
    assert_equal [%w(1Three), %w(2Three 2Two), %w(3Three 3Two 3One)], items.map { |ary| ary.map(&:name) }
  end
  
  test 'Inheritance' do
    subklass = Class.new(Item) { self.root = 'subitem' }
    assert_equal 'subitem', subklass.root
    assert_equal 'i', Item.root
  end
  
  test 'Validation method' do
    assert_equal true, orders.first.valid?
  end
  
  test 'Invalid data raises error' do
    assert_raise(XmlResource::ParseError) { Order.collection_from_xml({}) }
  end
  
  private
  
  def orders
    @orders
  end
  
end
