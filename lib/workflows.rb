require_relative 'workflows/version'
require_relative 'workflows/step'

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

  def initialize(service_args = {})
    # TODO: validate service_args
    # make sure there is one for each service
    # according to the wf structure defined with has_flow
    wf_steps.each do |wf_step|
      args = service_args.fetch(wf_step.name.to_sym)
      wf_step.set_args args
    end
  end

  def run(args = {})
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

  def status
    wf_steps.map { |wf_step| wf_step.status }
  end

  def output
    wf_steps.map { |wf_step| wf_step.output }
  end
end
