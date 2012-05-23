require 'public_suffix'

# URI mixin that adds method to get domain.
module Murlsh

  module URIDomain

    # Return the domain.
    def domain
      if host
        Murlsh.failproof do
          parsed = PublicSuffixService.parse(host.downcase)
          "#{parsed.sld}.#{parsed.tld}"
        end
      end
    end

  end

end
