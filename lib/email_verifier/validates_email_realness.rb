require "active_record"

module EmailVerifier
  module ValidatesEmailRealness
    
    module Validator
      class EmailRealnessValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, value)
          begin
            record.errors.add attribute, 'must point to a real mail account' unless EmailVerifier.check(value)
          rescue EmailVerifier::OutOfMailServersException
            record.errors.add attribute, 'appears to point to dead mail server'
          rescue EmailVerifier::NoMailServerException
            record.errors.add attribute, "appears to point to domain which doesn't handle e-mail"
          rescue EmailVerifier::FailureException
            record.errors.add attribute, "could not be checked if is real"
          end
        end
      end
    end
   
    module ClassMethods
      def validates_email_realness_of(*attr_names)
        validates_with ActiveRecord::Base::EmailRealnessValidator, _merge_attributes(attr_names)
      end
    end

  end
end

ActiveRecord::Base.send(:include, EmailVerifier::ValidatesEmailRealness::Validator)
ActiveRecord::Base.send(:extend,  EmailVerifier::ValidatesEmailRealness::ClassMethods)
