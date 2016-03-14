require 'ostruct'
require_relative 'step_service'

module Workflows
  class Step

    def self.build_all(steps = [])
      steps.map do |step_hash|
        new(step_hash)
      end
    end

    attr_reader :service_obj,
                :status,
                :output,
                :state,
                :name

    def initialize(args = {})
      @name = args[:name]
      @klass = args[:service]
      @strategy = args[:strategy] || :fail
      @service_args = args[:args]

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

    def set_args(args)
      service_obj.set_args args
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
