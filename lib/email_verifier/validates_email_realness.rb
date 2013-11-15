require "active_record"

module EmailVerifier
  module ValidatesEmailRealness
    
    module Validator
      class EmailRealnessValidator < ActiveModel::EachValidator
        def validate_each(record, attribute, value)
          begin
            record.errors.add attribute, I18n.t('errors.messages.test') unless EmailVerifier.check(value)
          rescue EmailVerifier::OutOfMailServersException
            record.errors.add attribute, 'punta ad un server mail inesistente'
          rescue EmailVerifier::NoMailServerException
            record.errors.add attribute, "punta ad un dominio che non gestisce le email"
          rescue EmailVerifier::FailureException
            record.errors.add attribute, "deve essere un indirizzo reale"
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
