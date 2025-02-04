class CreateFighters < ActiveRecord::Migration[8.0]
  def change
    create_table :fighters, id: :bigint, default: nil do |t|
      t.json :profile
      t.datetime :synchronized_at
      t.string :last_synchronized_replay_id
      t.timestamps
    end
  end
end
