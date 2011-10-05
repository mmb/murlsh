module Murlsh

  module Setup

    module_function

    # Concatenate some files and return the result as a string.
    def cat_files(files, sep=nil)
      result = ''
      files.each do |fname|
        open(fname) do |h|
          while (line = h.gets) do; result << line; end
          result << sep  if sep
        end
      end
      result
    end

  end

end
