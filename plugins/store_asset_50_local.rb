module Murlsh

  # Store assets on the local filesystem in the public directory.
  class StoreAsset50Local < Plugin

    @hook = 'store_asset'

    def self.run(name, data, config)
      # break apart and rejoin to use os path separator
      name_parts = name.split('/')
      local_path = File.join('public', name_parts)

      Murlsh.openlock(local_path, 'w') { |fout| fout.write data }

      name
    end

  end

end
