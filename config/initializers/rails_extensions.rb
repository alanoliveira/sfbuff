# frozen_string_literal: true

%w[ rails_ext ].each do |extensions_dir|
  Dir["#{Rails.root}/lib/#{extensions_dir}/*"].each { |path| require "#{extensions_dir}/#{File.basename(path)}" }
end
