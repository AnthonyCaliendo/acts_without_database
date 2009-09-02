require 'test_helper'

class ActsWithoutDatabaseObject < ActiveRecord::Base
  acts_without_database :created_at => :datetime, :some_string => :string, :some_int => :integer
  validates_presence_of :some_string
end

class AnotherActsWithoutDatabaseObject < ActiveRecord::Base
  acts_without_database :created_at => :datetime, :another_field => :string
end

class ActsWithoutDatabaseTest < ActiveSupport::TestCase

  test 'should typecast values' do
    time = Time.now
    object = ActsWithoutDatabaseObject.new :created_at => time.to_s, :some_int => '7'

    assert_equal 7, object.some_int
    assert_equal Time, object.created_at.class
    assert_equal time.to_s, object.created_at.to_s
  end

  test 'should validate field' do
    object = ActsWithoutDatabaseObject.new :some_string => nil

    assert !object.valid?
    assert_not_nil object.errors.on(:some_string)
  end

  test 'should not share columns between multiple classes' do
    assert !ActsWithoutDatabaseObject.columns.detect {|column| column.name == 'another_field'}
    assert !AnotherActsWithoutDatabaseObject.columns.detect {|column| column.name == 'some_string' || column.name == 'some_int'}
  end

end
