require 'pry'
require 'pry-byebug'

module Workflows
  module StepService
    ####
    # Getter, Setter methods
    ####

    def set_state(state)
      @wf_state = state
    end

    def get_state
      @wf_state
    end

    def set_output(output)
      @wf_output = output
    end

    def get_output
      @wf_output
    end
  end

  class Step
    class MissingRunMethodError < StandardError; end

    def self.build_all(steps = [])
      steps.map do |step_hash|
        new(step_hash)
      end
    end

    attr_reader :service_obj,
                :status,
                :output,
                :state

    def initialize(args = {})
      @name = args[:name]
      @klass = args[:service]
      @strategy = args[:strategy] || :fail

      @service_obj = @klass.new
    end

    def run
      @status = :ok
      service_obj.run
      @output = service_obj.get_output
    rescue => e
      @status = :fail
      @output = e.message
    ensure
      @state = service_obj.get_state
    end

    def set_state(state)
      service_obj.set_state state
    end

    def get_state
      service_obj.get_state
    end

    def get_output
      service_obj.get_output
    end
  end
end
