require 'workflows'

module Example::Signup
  module Models

    class User
      attr_reader :name, :dob
      attr_accessor :notified

      def initialize(name, dob)
        @name = name
        @dob = dob
        @notified = false
      end

      def create; true; end
      def notify; true; end
    end

    class Admin
      attr_accessor :notified

      def self.get
        new
      end

      def initialize
        @notified = false
      end

      def notify_about(user); true; end
    end
  end
end
