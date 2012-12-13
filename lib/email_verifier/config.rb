module EmailVerifier
  module Config
    class << self
      attr_accessor :verifier_email

      def reset
        @verifier_email = "nobody@nonexistant.com"
      end
    end
    self.reset
  end
end
