module Workflows
  class Step
    class MissingRunMethodError < StandardError; end

    def self.build_all(steps = [])
      steps.map do |step_hash|
        new(step_hash)
      end
    end

    attr_reader :service_obj

    def initialize(args = {})
      @name = args[:name]
      @klass = args[:service]
      @strategy = args[:strategy] || :fail

      @service_obj = @klass.new
    end

    def run
      service_obj.run
    rescue
      raise MissingRunMethodError, @klass
    end
  end
end
