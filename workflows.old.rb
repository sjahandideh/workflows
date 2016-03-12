require 'workflows/version'
require 'pry'
require 'pry-byebug'

module Workflows

  attr_reader :steps,
              :args

  def initialize(args={}, steps)
    @args = args
    @steps = Step.build steps
  end

  def call
    :ok
  end

  class Step
    def self.build(steps)
      steps.map do |step_hash|
        new step_hash
      end
    end

    attr_reader :name,
                :service_klass,
                :strategy

    def initialize(step_hash)
      @name = step_hash[:name]
      @service_klass = step_hash[:service]
      @strategy = step_hash[:strategy] || :fail
    end
  end
end
