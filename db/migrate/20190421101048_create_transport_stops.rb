class CreateTransportStops < ActiveRecord::Migration[5.2]
  def change
    create_table :transport_stops do |t|
      t.integer :x
      t.integer :y

      t.timestamps
    end
  end
end
