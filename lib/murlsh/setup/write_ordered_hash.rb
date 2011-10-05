require 'yaml'

module Murlsh

  module Setup

    module_function

    # Sort a hash by key and write it to a file as YAML.
    def write_ordered_hash(h, path)
      h.extend(YamlOrderedHash)
      h.each_value { |v| v.extend(YamlOrderedHash)  if v.is_a?(Hash) }

      open(path, 'w') { |f| YAML.dump(h, f) }
    end

  end

end
