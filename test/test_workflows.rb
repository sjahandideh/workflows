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
      state = {
        barbie: Barbie.new(*barbie_args)
      }
      set_state(state) # always the last command
    end

    def barbie_args
      ['female', 'Software Engineer']
    end
  end

  class Make
    include Workflows::StepService

    def run
      barbie = get_state[:barbie]
      msg = barbie.dress_up(outfit)

      set_output(msg)
      set_state(barbie: barbie)
    end

    def outfit
      'white shirt and navy shorts'
    end
  end

  has_flow [
    {
      name: 'one',
      service: Design
    },
    {
      name: 'two',
      service: Make
    }
  ]
end

describe Workflows do
  it "this." do
    barbie = BarbieMakerFlow::Barbie.new 'female', 'Software Engineer'
    BarbieMakerFlow::Barbie.stub(:new, 'female', 'Software Engineer') { barbie }

    bmf = BarbieMakerFlow.new
    bmf.run.must_equal "female Software Engineer barbie is wearing a white shirt and navy shorts"
#    bmf.state.must_be_kind_of BarbieMakerFlow::Barbie

    engineer_barbie = bmf.state[:barbie]
    engineer_barbie.gender.must_equal 'female'
    engineer_barbie.specification.must_equal 'Software Engineer'
    engineer_barbie.outfit.must_equal 'white shirt and navy shorts'
  end
end
