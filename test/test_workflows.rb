require "minitest/autorun"
require "workflows"

class BarbieMakerFlow
  include Workflows

  class Barbie
    attr_reader :gender,
                :specification,
                :outfit

    def initialize(gender, specification)
      @gender = gender
      @specification = specification
    end

    def dress_up(outfit)
      @outfit = outfit
      "#{@gender} #{@specification} barbie is wearing a #{outfit}"
    end
  end

  class Design
    include Workflows::StepService

    def run
      set_state(
        barbie: Barbie.new(args.gender, args.specification)
      )
    end
  end

  class Make
    include Workflows::StepService

    def run
      barbie = get_state[:barbie]
      msg = barbie.dress_up(args.outfit)

      set_output(msg)
      set_state(barbie: barbie)
    end
  end

  has_flow [
    {
      name: 'design',
      service: Design,
      args: [:gender, :specification]
    },
    {
      name: 'make',
      service: Make,
      args: [:outfit]
    }
  ]

end

describe Workflows do
  before do
    ### setup
    barbie = BarbieMakerFlow::Barbie.new 'female', 'Software Engineer'
    BarbieMakerFlow::Barbie.stub(:new, 'female', 'Software Engineer') { barbie }

    ### subject
    @bmf = BarbieMakerFlow.new(
      design: { gender: 'female', specification: 'Software Engineer' },
      make: { outfit: 'white shirt and navy shorts' }
    )
  end

  it "output is correct" do
    @bmf.run.
      must_equal "female Software Engineer barbie is wearing a white shirt and navy shorts"
  end

  it "state is correct" do
    @bmf.run
    engineer_barbie = @bmf.state[:barbie]
    engineer_barbie.must_be_kind_of BarbieMakerFlow::Barbie
    engineer_barbie.gender.must_equal 'female'
    engineer_barbie.specification.must_equal 'Software Engineer'
    engineer_barbie.outfit.must_equal 'white shirt and navy shorts'
  end
end
