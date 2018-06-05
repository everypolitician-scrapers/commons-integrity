# frozen_string_literal: true

require_relative 'base'
require 'csv'
require 'json'

module Commons
  module Integrity
    class Check
      # Ensure we have rich position data for positions associated with boundaries
      #
      # This check should be applied to a
      # boundaries/build/position-data.json file. It'll check
      # that that file has data for every position mentioned in
      # the index.json file in the same directory.
      #
      # == Configuration Options
      class AreaPositionsKnown < Base
        # @return [Array<Error>]
        # Errors will be in the category `:position_id_message`
        def errors
          positions_missing_role_data.map do |position|
            error(
              position_id_message: "#{position} was found in #{boundaries_index_pathname} but not in #{pathname}"
            )
          end
        end

        private

        def positions_missing_role_data
          (position_items_from_index - positions_with_role_data).sort
        end

        def boundaries_index_pathname
          pathname.dirname.join('index.json')
        end

        def boundaries_index_data
          @boundaries_index_data ||= JSON.parse(
            boundaries_index_pathname.read,
            symbolize_names: true
          )
        end

        def position_items_from_index
          Set.new(
            boundaries_index_data.flat_map do |entry|
              BoundaryIndexEntry.new(entry).associated_positions
            end
          )
        end

        def positions_with_role_data
          Set.new(
            JSON.parse(pathname.read, symbolize_names: true).map do |role|
              role[:role_id]
            end
          )
        end
      end
    end

    # This encapsulates a top-level entry in the JSON file which
    # acts as an index of the boundary data directories
    class BoundaryIndexEntry
      def initialize(entry_data)
        @entry_data = entry_data
      end

      def associated_positions
        entry_data[:associations].map { |association| association[:position_item_id] }
      end

      private

      attr_reader :entry_data
    end
  end
end
