# frozen_string_literal: true

require_relative 'base'
require 'csv'

class Commons
  class Integrity
    class Check
      # Check that any values in the `wikidata` column look like valid IDs
      class WikidataIdentifiers < Base
        def errors
          problematic_values.map { |val| error(wikidata_id_format: "Invalid wikidata ID: #{val}") }
        end

        private

        DEFAULT_COLUMN_NAME = 'wikidata'
        DEFAULT_COLUMN_CASE = 'any'

        def csv
          @csv ||= CSV.read(pathname, headers: true)
        end

        def headers
          csv.headers
        end

        def column_name
          my_config.to_h['column_name'] || DEFAULT_COLUMN_NAME
        end

        def comparison_type
          my_config.to_h['column_case'] || DEFAULT_COLUMN_CASE
        end

        def comparison_conversion
          return :to_s if comparison_type == 'fixed'
          :downcase
        end

        def wikidata_column
          headers.find { |header| header.send(comparison_conversion) == column_name.send(comparison_conversion) }
        end

        def wikidata_column?
          wikidata_column
        end

        def wikidata_values
          return [] unless wikidata_column?
          csv.map { |row| row[wikidata_column] }
        end

        def problematic_values
          wikidata_values.reject { |value| value =~ /^Q[1-9][0-9]*$/ }
        end
      end
    end
  end
end
