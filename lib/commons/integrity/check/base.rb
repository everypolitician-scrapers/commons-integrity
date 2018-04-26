# frozen_string_literal: true

class Commons
  class Integrity
    class Check
      # All other checks should inherit from here, and override `errors`
      class Base
        def initialize(filename)
          @filename = filename
        end

        def errors
          []
        end

        private

        attr_reader :filename

        # Simple struct to represent any errors raised
        Error = Struct.new(:category, :message, :filename)

        def error(pair)
          Error.new(*pair.first, filename)
        end

        def config
          @config ||= Config.new
        end

        def pathname
          @pathname ||= Pathname.new(filename)
        end
      end
    end
  end
end
