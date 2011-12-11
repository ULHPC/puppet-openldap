# hash a string as slappasswd command would do it
require 'digest/sha1'
require 'base64'

module Puppet::Parser::Functions
  newfunction(:slappasswd, :type => :rvalue) do |args|
    # Source : http://www.openldap.org/faq/data/cache/347.html
    salt = args[0]
    '{SSHA}' + Base64.encode64( Digest::SHA1.digest(args[1] + salt) + salt ).chomp!
  end
end

