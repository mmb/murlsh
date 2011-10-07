require 'csv'
require 'digest/md5'

require 'bcrypt'

module Murlsh

  # Interface to authentication file. Format of authentication file:
  #
  # username,MD5 hash of email address,bcrypted password
  #
  # Authentication is done using password only to make adding easier and
  # because there will be a small number of trusted users.
  #
  # See Rakefile for user maintenance tasks.
  class Auth

    def initialize(file); @file = file; end

    # Handle differences in csv interface between ruby 1.8 and 1.9.
    def self.csv_iter(csv_file, &block)
      if defined?(CSV::Reader)
        # ruby 1.8
        CSV::Reader.parse(open(csv_file), &block)
      else
        # ruby 1.9
        CSV.foreach(csv_file, &block)
      end
    end

    # Authenticate a user by password. Return their name and email if correct.
    def auth(password)
      self.class.csv_iter(@file) do |row|
        return { :name => row[0], :email => row[1] }  if
          BCrypt::Password.new(row[2]) == password
      end
    end

    # Add a user to the authentication file.
    def add_user(username, email, password)
      Murlsh.openlock(@file, 'a') do |f|
        f.write "#{[username, Digest::MD5.hexdigest(email),
          BCrypt::Password.create(password)].join(',')}\n"
      end
    end

    # Look up a user by email address.
    #
    # Return nil if not found.
    def by_email(email)
      hash = Digest::MD5.hexdigest(email)

      self.class.csv_iter(@file) do |row|
        return { :name => row[0], :email => row[1] }  if hash == row[1]
      end

    end

  end

end
