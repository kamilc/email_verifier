require 'net/smtp'

class EmailVerifier::Checker
  
  ##
  # Returns server object for given email address or throws exception
  # Object returned isn't yet connected. It has internally a list of 
  # real mail servers got from MX dns lookup
  def initialize(address)
    @email   = address
    @domain  = address.split("@").last
    @servers = list_mxs @domain
    raise EmailVerifier::NoMailServerException.new("No mail server for #{address}") if @servers.empty?
    @smtp    = nil

    # this is because some mail servers won't give any info unless 
    # a real user asks for it:
    @user_email = EmailVerifier.config.verifier_email
  end

  def list_mxs(domain)
    `host -t MX #{domain}`.scan(/(?<=by ).+/).map do |mx| 
      res = mx.split(" ")
      next if res.last[0..-2].strip.empty?
      { priority: res.first.to_i, address: res.last[0..-2] }
    end.reject(&:nil?).sort_by { |mx| mx[:priority] }
  end

  def is_connected
    !@smtp.nil?
  end

  def connect
    begin
      server = next_server
      raise EmailVerifier::OutOfMailServersException.new("Unable to connect to any one of mail servers for #{@email}") if server.nil?
      @smtp = Net::SMTP.start(server[:address], 25)
      return true
    rescue EmailVerifier::OutOfMailServersException => e
      return false
    rescue => e
      retry
    end
  end

  def next_server
    @servers.shift
  end

  def verify
    self.helo @user_email
    self.mailfrom @user_email
    self.rcptto(@email)
  end

  def helo(address)
    ensure_connected

    ensure_250 @smtp.helo(@domain)
  end

  def mailfrom(address)
    ensure_connected

    ensure_250 @smtp.mailfrom(address)
  end

  def rcptto(address)
    ensure_connected
   
    begin
      ensure_250 @smtp.rcptto(address)
    rescue => e
      if e.message[/^550/]
        return false
      else
        raise EmailVerifier::FailureException.new(e.message)
      end
    end
  end

  def ensure_connected
    raise EmailVerifier::NotConnectedException.new("You have to connect first") if @smtp.nil?
  end

  def ensure_250(smtp_return)
    if smtp_return.status.to_i == 250
      return true
    else
      raise EmailVerifier::FailureException.new "Mail server responded with #{smtp_return.status} when we were expecting 250"
    end
  end

end
