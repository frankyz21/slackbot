class CreateIncidents < ActiveRecord::Migration[7.0]
  def change
    create_table :incidents do |t|
      t.string :title, null: false
      t.text :description
      t.integer :severity, null: false
      t.integer :status
      t.timestamp :resolved_at
      t.string :creator, null: false
      t.string :channel_id

      t.timestamps
    end
  end
end
