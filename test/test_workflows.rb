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
      proc { @flow.run }.
        must_raise Workflows::Step::MissingRunMethodError
    end

    it "returns success when all steps run successfully" do
    end
  end
end
