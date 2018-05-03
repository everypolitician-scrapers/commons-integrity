# frozen_string_literal: true

# Wrapper around Popolo JSON data to provide a consistent interface
class Popolo
  def initialize(data)
    @data = data
  end

  attr_reader :data

  def languages_in_use
    items.flat_map(&:languages_in_use).to_set
  end

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

  def languages_in_use
    data.keys.flat_map { |key| self[key].languages_in_use }
  end

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

  def languages_in_use
    return [] unless value.is_a? Hash
    value.keys.map { |key| key.scan(/^lang:(.*)/) }.flatten
  end
end
