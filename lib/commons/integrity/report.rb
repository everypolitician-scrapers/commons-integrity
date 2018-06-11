# frozen_string_literal: true

require 'active_support/core_ext/class/subclasses'
require 'require_all'

require_relative 'config'
require_rel 'check'

class Commons
  class Integrity
    # Collate the errors from all reports applying to a file
    class Report
      def initialize(file:, config: nil)
        @file = Pathname.new(file)
        @config = config
      end

      def errors
        relevant_checks.flat_map { |check| check.new(file).errors }
      end

      private

      attr_reader :file, :config

      def relevant_checks
        return [] unless config
        config.checks.select { |check| check.new(file, config: config).applies? }
      end
    end
  end
end
