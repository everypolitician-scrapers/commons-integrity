# frozen_string_literal: true

require_relative 'base'
require 'csv'

module Commons
  module Integrity
    class Check
      # Check that any values in a "wikidata" column look like valid IDs
      #
      # Given a CSV file with a column of Wikidata identifiers, this
      # Check will ensure that all the values in that column look like
      # valid identifiers (i.e. are Q-numbers). It does *not* check that
      # they are _actually_ valid IDs: only that they are of the correct
      # form.
      #
      # == Configuration Options
      # * column_name: the column containing the IDs (default: "wikidata")
      # * column_case: "fixed" if the column_name must be exactly as specified (default: "any")
      class WikidataIdentifiers < Base
        # @return [Array<Error>]
        # Errors will be in the category `:wikidata_id_format`
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
