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

        def csv
          @csv ||= CSV.read(pathname, headers: true)
        end

        def headers
          csv.headers
        end

        def wikidata_column
          # TODO: allow configuration of capitalisation etc.
          headers.find { |header| header.downcase == 'wikidata' }
        end

        def wikidata_column?
          wikidata_column
        end

        def wikidata_values
          return unless wikidata_column?
          csv.map { |row| row[wikidata_column] }
        end

        def problematic_values
          wikidata_values.reject { |value| value =~ /^Q[1-9][0-9]*$/ }
        end
      end
    end
  end
end
