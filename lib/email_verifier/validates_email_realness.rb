if defined?(ActiveSupport)
  ActiveSupport.on_load(:active_record) do

    module EmailVerifier
      module ValidatesEmailRealness

        module Validator
          class EmailRealnessValidator < ActiveModel::EachValidator
            def validate_each(record, attribute, value)
              begin
                record.errors.add attribute, I18n.t('errors.messages.email_verifier.email_not_real') unless EmailVerifier.check(value)
              rescue EmailVerifier::OutOfMailServersException
                record.errors.add attribute, I18n.t('errors.messages.email_verifier.out_of_mail_server')
              rescue EmailVerifier::NoMailServerException
                record.errors.add attribute, I18n.t('errors.messages.email_verifier.no_mail_server')
              rescue EmailVerifier::FailureException
                record.errors.add attribute, I18n.t('errors.messages.email_verifier.failure')
              rescue Exception
                record.errors.add attribute, I18n.t('errors.messages.email_verifier.exception')
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
  end
end
