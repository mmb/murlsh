require 'fileutils'

module Murlsh

  module Setup

    MurlshRoot = File.join(File.dirname(__FILE__), '..', '..', '..')

    module_function

    # Install a murlsh site to a web directory.
    #
    # Copies files that are different per-site to make a site instance.
    def install(dest_dir)
      Setup.cp_r_safe(
        %w{
          .htaccess
          Rakefile
          config/
          config.ru
          config.yaml
          db/
          plugins/
          public/
        }.map { |x| File.join(MurlshRoot, x) }, dest_dir, :verbose => true)

      FileUtils.mkdir_p(File.join(dest_dir, 'tmp'), :verbose => true)
    end

  end

end
