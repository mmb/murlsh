require 'net/pop'

require 'active_record'
require 'postrank-uri'
require 'rmail'

module Murlsh

  # Pop mail from a pop3 server and add all urls in messages from murlsh users.
  class PopServer < Server

    def post(req)
      response_body = []

      if req['secret'] == config['pop_secret']
        Net::POP3.enable_ssl
        Net::POP3.start(config.fetch('pop_server'), config.fetch('pop_port'),
          config.fetch('pop_user'), config.fetch('pop_password')) do |pop|
          pop.each_mail do |mail|
            begin
              response_body << process_mail(mail.pop)
            rescue Exception
            ensure
              mail.delete
            end
          end
          pop.finish
        end
      end

      build_response response_body.to_json, 200,
        'Content-Type' => 'application/json'
    end

    # Authenticate the sender and add all urls extracted from the the email
    # body.
    def process_mail(mail)
      parsed_mail = parse_mail(mail)

      if user = Auth.new(config.fetch('auth_file')).by_email(
        parsed_mail[:from])
        parsed_mail[:uris].each do |uri|
          mu = Url.new do |u|
            u.url = uri
            u.email = user[:email]
            u.name = user[:name]
            u.time = parsed_mail[:date]
          end

          # validate before add_pre plugins have run and also after (in save!)
          raise ActiveRecord::RecordInvalid.new(mu)  unless mu.valid?
          Plugin.hooks('add_pre') { |p| p.run mu, config }
          mu.save!
          Plugin.hooks('add_post') { |p| p.run mu, config }
        end
      end
      parsed_mail
    end

    # Parse date, from address and urls found in body from an email message.
    def parse_mail(mail)
      parsed_mail = RMail::Parser.read(mail.gsub(/\r/, ''))

      {
        :date => parsed_mail.header.date.utc,
        :from => parsed_mail.header.from.first.address.downcase,
        :uris => PostRank::URI.extract(parsed_mail.body),
      }    
    end

  end

end
