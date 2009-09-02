module ActsWithoutDatabase
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def acts_without_database(columns = {:id => :integer})
      @columns = columns.collect do |name, type|
        ActiveRecord::ConnectionAdapters::Column.new name.to_s, nil, type.to_s, false
      end
    end
  end

end  