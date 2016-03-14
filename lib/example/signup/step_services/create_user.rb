require 'workflows'

require_relative '../models'

module Example::Signup

  class CreateUserService
    include Workflows::StepService

    def run
      user = Models::User.new(args.name, args.dob)
      if user.create
        # success
        set_state(user: user)
        set_output "#{user.name} is successfully created."
      else
        # failure
        raise "Unable to create user"
      end
    end
  end
end
