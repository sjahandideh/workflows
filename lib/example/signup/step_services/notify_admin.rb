require 'workflows'

module Example::Signup

  class NotifyAdminService
    include Workflows::StepService

    def run
      if admin.notify_about(user)
        # no need to reset the state
        set_output "Admin is notified."
      else
        raise "Unable to notify admin about new user"
      end
    end

    private

    def user
      @user ||= get_state.user
    end

    def admin
      @admin ||= args.admin
    end
  end
end
