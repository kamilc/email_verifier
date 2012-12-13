require "email_verifier/version"

module EmailVerifier
  require 'email_verifier/checker'
  require 'email_verifier/exceptions'
  require 'email_verifier/config'
  require "email_verifier/validates_email_realness"

  def self.check(email)
    v = EmailVerifier::Checker.new(email)
    v.connect
    v.verify
  end

  def self.config(&block)
    if block_given?
      block.call(EmailVerifier::Config)
    else
      EmailVerifier::Config
    end
  end
end
