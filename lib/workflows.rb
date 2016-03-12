require 'workflows/version'
require 'workflows/step'

# TODO: remove me
require 'pry'
require 'pry-byebug'

module Workflows

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def has_flow(args = [])
      class_eval <<-EVAL, __FILE__, __LINE__ + 1
        def steps
          @steps ||= Step.build_all(#{args})
        end
      EVAL
    end
  end

  ####
  # instance methods
  ####

  def run
    steps.map do |step|
      step.run
    end
  end
end
