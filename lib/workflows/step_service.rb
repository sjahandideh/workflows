require 'ostruct'
require 'pry'
require 'pry-byebug'

module Workflows
  module StepService

    ####
    # Getter, Setter methods
    ####

    def set_args(args)
      @wf_args ||=
        OpenStruct.new(args)
    end

    def args
      @wf_args
    end
    alias :get_args :args

    def set_state(state)
      @wf_state = OpenStruct.new(state)
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
end
