require "minitest/autorun"
require "workflows"

class BarbieMakerFlow
  include Workflows

  class Design; end
  class Make; end

  has_flow [
    { name: 'one', service: Design },
    { name: 'two', service: Make }
  ]
end

describe Workflows do
  before { @flow = BarbieMakerFlow.new }

  describe ".has_flow" do
    it "has a flow" do
      @flow.steps.size.must_equal 2
    end
  end

  describe ".run" do
    it "raises MissingRunMethod execption when a service doesn't have a run method" do
      BarbieMakerFlow::Design.class_eval { if method_defined?(:run); undef :run; end }

      proc { @flow.run }.
        must_raise Workflows::Step::MissingRunMethodError
    end

    it "returns success when all steps run successfully" do
      BarbieMakerFlow::Design.class_eval { def run; :success; end }
      BarbieMakerFlow::Make.class_eval { def run; :success; end }

      flow = BarbieMakerFlow.new
      flow.run.must_equal [:success, :success]
    end

    it "returns success when all steps run successfully" do
      BarbieMakerFlow::Design.class_eval { def run; :fail; end }
      BarbieMakerFlow::Make.class_eval { def run; :fail; end }

      flow = BarbieMakerFlow.new
      flow.run.must_equal [:fail, :fail]
    end
  end
end
