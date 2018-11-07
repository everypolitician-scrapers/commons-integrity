# frozen_string_literal: true

require 'json'
require_relative 'base'
require 'commons/integrity/popolo'

class Commons
  class Integrity
    class Check
      # Check that no Popolo JSON file has labels in a language not specified in the commons-builder config.json
      class Languages < Base
        def errors
          unexpected_languages.map { |lang| error(unexpected_language: "Unexpected language: #{lang}") }
        end

        private

        def unexpected_languages
          languages_in_use - allowed_languages
        end

        def languages_in_use
          popolo.languages_in_use
        end

        def popolo
          @popolo ||= Popolo.new(data)
        end

        def data
          @data ||= JSON.parse(File.open(pathname, 'r').read)
        end

        def allowed_languages
          @allowed_languages ||= Set.new(my_config['allowed_languages'])
        end
      end
    end
  end
end
