require 'json-schema'

module MatchSchema
  class MatchSchemaMatcher
    def initialize(name)
      @name = name
    end

    def description
      "match JSON schema #{@name.inspect}"
    end

    def failure_message
      @errors.join("\n")
    end

    def failure_message_when_negated
      "Expected object to not match JSON schema #{@name.inspect}"
    end

    def matches?(actual)
      @errors = JSON::Validator.fully_validate(@name, actual)

      if @errors.empty?
        true
      else
        @errors.unshift("Expected object to match JSON schema #{@name.inspect}")
        false
      end
    end
  end

  def match_schema(name)
    MatchSchemaMatcher.new(name)
  end
end

RSpec.configure do |config|
  config.include MatchSchema
end
