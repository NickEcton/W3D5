require 'byebug'
require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    @data ||= DBConnection::execute2(<<-SQL)
      SELECT
        *
      FROM
        #{self.table_name}
      SQL
    @data[0].map { |el| el.to_sym }
  end

  def self.finalize!
    self.columns.each do |col|
      define_method(col) do
        self.attributes[col]
      end
      define_method("#{col}=") do |value|
        self.attributes[col] = value
      end
    end
  end

  def self.table_name=(table_name)
    @name = table_name
  end

  def self.table_name
    @name ||= self.to_s.tableize
  end

  def self.all
    hashes = DBConnection.execute(<<-SQL)
    SELECT
      *
    FROM
      #{table_name}
    SQL
    self.parse_all(hashes)
  end

  def self.parse_all(results)
    results.map { |hash| new(hash) }
  end

  def self.find(id)
    # debugger
    attributes = DBConnection.execute(<<-SQL, id)
    SELECT
      *
    FROM
      #{self.table_name}
    WHERE
      id = ?
    SQL
    return nil if attributes.empty?
    cat = Cat.new(attributes[0])
    return cat
  end

  def initialize(params = {})
    params.each do |key, val|
      key = key.to_sym
      if self.class.columns.include?(key)
        send("#{key}=", val)
      else
        raise "unknown attribute '#{key}'"
      end
    end
    # ...
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
