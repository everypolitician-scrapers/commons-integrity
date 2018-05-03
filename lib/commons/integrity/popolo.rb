# frozen_string_literal: true

# Wrapper around Popolo JSON data to provide a consistent interface
class Popolo
  def initialize(data)
    @data = data
  end

  attr_reader :data

  def items
    data.values.flatten.map { |item| PopoloItem.new(item) }
  end
end

# Wrapper around Popolo item JSON
class PopoloItem
  def initialize(data)
    @data = data
  end

  attr_reader :data

  def [](key)
    PopoloValue.new(data[key])
  end
end

# Wrapper around Popolo value JSON
class PopoloValue
  def initialize(value)
    @value = value
  end

  attr_reader :value
end
