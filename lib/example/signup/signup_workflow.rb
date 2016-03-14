require 'workflows'
require_relative 'models'
require_relative 'step_services/create_user'
require_relative 'step_services/notify_user'
require_relative 'step_services/notify_admin'

module Example::Signup
  # @example
  #   signup_wf = Example::Signup::SignupWorkflow.new(
  #     create_user:  { name: 'Harry Potter', dob: '31-07-1980' },
  #     notify_user:  {},
  #     notify_admin: { admin: Example::Signup::Models::Admin.get }
  #   )
  #
  #   signup_wf.run
  #   signup_wf.status -> [:ok, :ok, :fail]
  #   signup_wf.output -> ["Harry Potter is successfully created.", "Harry Potter is notified", "Admin is notified"]
  #   signup_wf.state  -> Models::User.new(name: 'Harry Potter', ...)
  ###
  class SignupWorkflow
    include Workflows

    has_flow [
      {
        name: 'create_user',
        service: Example::Signup::CreateUserService,
        args: [:name, :dob]
      },
      {
        name: 'notify_user',
        service: Example::Signup::NotifyUserService,
        args: []
      },
      {
        name: 'notify_admin',
        service: Example::Signup::NotifyAdminService,
        args: [:admin]
      }
    ]
  end
end
