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

      ALL_CHECKS = Commons::Integrity::Check::Base.descendants

      def relevant_checks
        return [] unless config
        ALL_CHECKS.select do |check|
          check_config = config.for(check.moniker)
          if check_config
            pattern = check_config.dig('AppliesTo')
            file.fnmatch pattern if pattern
          end
        end
      end
    end
  end
end
