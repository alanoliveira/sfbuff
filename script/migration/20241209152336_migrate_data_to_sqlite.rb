require_relative "../../config/environment"
CHUNK_SIZE = 1000

def primary_conn = ActiveRecord::Base.establish_connection(:primary)
def migration_conn = ActiveRecord::Base.establish_connection(:migration)

[ :battles, :challengers, :players ].each do |table_name|
  last_id = migration_conn.with_connection { _1.select_value("SELECT id FROM #{table_name} ORDER BY id DESC") } || 0

  puts "Migrating #{table_name} starting from #{last_id}"

  (0..).step(CHUNK_SIZE).each do |offset|
    puts "Migrating #{table_name} at offset #{offset}" if offset % 100_000 == 0

    data = primary_conn.with_connection do |conn|
      conn.select_all("SELECT * FROM #{table_name} WHERE id > #{last_id} ORDER BY id LIMIT #{CHUNK_SIZE} OFFSET #{offset}")
        .map(&:to_h)
    end

    break if data.empty?

    migration_conn.with_connection do |conn|
      data.each { conn.insert_fixture(_1, table_name) }
    end
  end
end
