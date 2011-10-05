require 'fileutils'

module Murlsh

  module Setup

    module_function

    # Recursive copy from sources to destination but ask before overwriting.
    #
    # Options are passed into FileUtils.mkdir_p FileUtils.copy.
    def cp_r_safe(sources, dest, options)
      sources.each do |source|
        new = File.join(dest, File.split(File.expand_path(source)).last)

        if File.directory?(source)
          FileUtils.mkdir_p(new, options)
          cp_r_safe(Dir.entries(source).
            reject { |f| %w{. ..}.include?(f) }.
            map { |f| File.join(source, f) }, new, options)
        else
          answer = if File.exists?(new)
            Setup.ask("#{new} exists. Overwrite?", 'n')
          else
            'y'
          end

          FileUtils.copy(source, new, options)  if answer == 'y'
        end
      end
    end

  end

end
