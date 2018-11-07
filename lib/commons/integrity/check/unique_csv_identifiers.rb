# frozen_string_literal: true

require_relative 'base'
require 'csv'

module Commons
  module Integrity
    class Check
      # Check that any values in the given columns are unique within the file
      #
      # == Configuration Options
      # * column_names: the columns containing the IDs (default: ["wikidata", "ms_fb"])
      # * column_case: "fixed" if the column_name must be exactly as specified (default: "any")
      class UniqueCSVIdentifiers < Base
        # @return [Array<Error>]
        # Errors will be in the category `:unique_csv_identifiers`
        def errors
          return [] unless pathname_regex.match? pathname.to_s
          duplicate_values.map do |column_name, value|
            error(unique_csv_identifiers: "Duplicated #{column_name} value: #{value}")
          end
        end

        private

        DEFAULT_COLUMN_NAMES = %w[wikidata ms_fb].freeze
        DEFAULT_COLUMN_CASE = 'any'

        def csv
          @csv ||= CSV.read(pathname, headers: true)
        end

        def pathname_regex
          Regexp.new(my_config.to_h['pathname_regex'] || '.*')
        end

        def headers
          csv.headers
        end

        def column_names
          (my_config.to_h['column_names'] || DEFAULT_COLUMN_NAMES).map do |column_name|
            column_name.send(comparison_conversion)
          end
        end

        def comparison_type
          my_config.to_h['column_case'] || DEFAULT_COLUMN_CASE
        end

        def comparison_conversion
          return :to_s if comparison_type == 'fixed'
          :downcase
        end

        def columns
          headers.select do |header|
            column_names.include? header.send(comparison_conversion)
          end
        end

        def duplicate_values_for_column(column_name)
          csv.values_at(column_name).map(&:first).group_by(&:itself).select do |_group, values|
            values.length > 1
          end.keys
        end

        def duplicate_values
          columns.flat_map do |column_name|
            [column_name].product duplicate_values_for_column(column_name)
          end
        end
      end
    end
  end
end
