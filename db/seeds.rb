# This file should ensure the existence of records required to run the application.
# To add seed data, create or modify a file in the db/seeds directory according to the environment
# or use 'all.rb' to add seed data for all environments.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

["all", Rails.env].each do |seed|
  seed_file = Rails.root.join("db", "seeds", "#{seed}.rb")
  if File.exist?(seed_file)
    require seed_file
  end
end
