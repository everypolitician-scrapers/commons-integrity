# frozen_string_literal: true

require 'active_support/core_ext/class/subclasses'
require 'require_all'

require_relative 'config'
require_rel 'check'
require 'yaml'

class Commons
  class Integrity
    # This represents the configuration. For now we only have a single
    # config file, but I expect this will become more complex later, and
    # will likely need split into an abstract `Config` combining
    # multiple `Config::File` objects.
    class Config
      def initialize(supplied_location = nil)
        @supplied_location = supplied_location
      end

      def for(check)
        yaml[check]
      end

      def checks
        @checks ||= ALL_CHECKS.select { |check| self.for(check.moniker) }
      end

      private

      attr_reader :supplied_location

      DEFAULT_LOCATION = Pathname.pwd + '.integrity.yml'

      ALL_CHECKS = Commons::Integrity::Check::Base.descendants

      def yaml
        return {} unless config_exists?
        @yaml ||= YAML.load_file(pathname)
      end

      def possible_file_locations
        [supplied_location, DEFAULT_LOCATION]
      end

      def pathname
        possible_file_locations.compact.find { |file| Pathname.new(file).exist? }
      end

      def config_exists?
        pathname
      end
    end
  end
end
