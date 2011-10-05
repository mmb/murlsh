require 'yaml'

module Murlsh

  module Setup

    # Hash mixin to generate yaml with hash keys in sorted order.
    module YamlOrderedHash

      def to_yaml(opts={})
        YAML::quick_emit(self, opts) do |out|
          out.map(taguri, to_yaml_style) do |map|
            sort { |a,b| a[0].to_s <=> b[0].to_s }.each do |k, v|
              map.add k, v
            end
          end
        end
      end

    end

  end

end
