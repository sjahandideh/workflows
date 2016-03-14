# Workflows

Workflows is an attempt to create multiple-step services. each step of
the workflow is service by itself that has a run method. it can fail or
succeed and the status of the step will change to :fail or :ok
respectively. each service in this model has two types of output. one
that is called state and another that is called output. state will be
passed to the next step of the workflow, so if there are objects that
need to be passed between the steps, they should be kept in state.
outputs are not passed between the steps and are only holding the output
value of each executed step of the workflow.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'workflows'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install workflows

## Example

You can find more examples in the example directory of the gem.

If you have a workflow such as the following:

```ruby
class BarbieMakerFlow
  include Workflows


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
```

you can now run your flow by providing input arguments for each step:

```ruby
bmf = BarbieMakerFlow.new(
  design: { gender: 'female', specification: 'Software Engineer' },
  make: { outfit: 'white shirt and navy shorts' }
)

bmf.run  #=> runs the flow with provided inputs
bmf.status #=> [:ok, :ok] | [:ok, :fail] | [:fail, :fail]
bmf.output #=> ['output of design', 'output of make']
bmf.state #=> Barbie.new(gender: 'female',
specification: ....)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sjahandideh/workflows. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](CODE_OF_CONDUCT.md) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

