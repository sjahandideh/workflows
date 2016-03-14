require 'minitest/autorun'
require_relative '../../../lib/example/signup'
require_relative '../../../lib/example/signup/models'

module Example::Signup

  describe SignupWorkflow do

    describe "when successful" do
      before do
        @signup_wf = SignupWorkflow.new(
         create_user:  { name: 'Harry Potter', dob: '31-07-1980' },
         notify_user:  {},
         notify_admin: { admin: Models::Admin.get }
        )

        @signup_wf.run
      end

      it "the status is [:ok, :ok, :ok]" do
        @signup_wf.status.must_equal [:ok, :ok, :ok]
      end

      it "the output is an array of all step outputs" do
        @signup_wf.output.must_equal [
          "Harry Potter is successfully created.",
          "Harry Potter is notified.",
          "Admin is notified."]
      end

      it "the state is the user that is created and notified" do
        @signup_wf.state.user.must_be_kind_of Models::User
        user = @signup_wf.state.user

        user.name.must_equal "Harry Potter"
        user.notified.must_equal true
      end
    end

  end
end
