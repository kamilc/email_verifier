module EmailVerifier
  module Config
    class << self
      attr_accessor :verifier_email
      attr_accessor :test_mode

      def verifier_domain
        @verifier_domain ||= verifier_email.split("@").last
      end

      def reset
        @verifier_email = "nobody@nonexistant.com"
        @test_mode = false
        if defined?(Rails) and defined?(Rails.env) and Rails.env.test?
          @test_mode = true
        end
        @verifier_domain = nil
      end
    end
    self.reset
  end
end
