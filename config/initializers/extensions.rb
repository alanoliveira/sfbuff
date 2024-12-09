Dir["#{Rails.root}/lib/extensions/*"].each { |path| require "extensions/#{File.basename(path)}" }
