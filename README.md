# Workflows

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/workflows`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

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

