require 'workflows/version'
require 'workflows/step'

require 'pry'
require 'pry-byebug'

module Workflows

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def has_flow(args = [])
      class_eval <<-EVAL, __FILE__, __LINE__ + 1
        def wf_steps
          @wf_steps ||= Step.build_all(#{args})
        end
      EVAL
    end
  end

  ####
  # instance methods
  ####

  def run
    previous_state = {}
    wf_steps.each do |wf_step|
      wf_step.set_state(previous_state)
      wf_step.run
      previous_state = wf_step.get_state
    end

    wf_steps.last.get_output
  end

  def state
    wf_steps.last.get_state
  end
end
