require 'workflows'

module Example::Signup

  class NotifyUserService
    include Workflows::StepService

    def run
      if user.notify
        user.notified = true
        set_state(user: user)
        set_output "#{user.name} is notified."
      else
        raise "Unable to notify user"
      end
    end

    private

    def user
      @user ||= get_state.user
    end
  end
end
