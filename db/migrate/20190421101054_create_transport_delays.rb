class CreateTransportDelays < ActiveRecord::Migration[5.2]
  def change
    create_table :transport_delays do |t|
      t.references :transport_line
      t.integer :delay

      t.timestamps
    end
  end
end
