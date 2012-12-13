# Email Verifier

Helper validation utility for checking whether given email address is real or not.
Many times as developers we've put in our models statements for checking email address
*format*. This gem will complete your existing setups with validator that actually
connects with given mail server and asks if given email address exists for real.

## Installation

Add this line to your application's Gemfile:

    gem 'email_verifier'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install email_verifier

## Usage

Just put this in your model e. g:
    
    validates_email_realness_of :email

Or - if you'd like to use it outside of your models:

    EmailValidator.check(youremail)

This method will return true or false, or - will throw exception 
with nicely detailed info about what's wrong.

## Credits
![End Point Corporation](http://www.endpoint.com/images/end_point.png)

Email Verifier is maintained and funded by [End Point Corporation](http://www.endpoint.com/)

Please send questions to [kamil@endpoint.com](mailto:kamil@endpoint.com)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
