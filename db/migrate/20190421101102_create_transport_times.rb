class CreateTransportTimes < ActiveRecord::Migration[5.2]
  def change
    create_table :transport_times do |t|
      t.references :transport_stop
      t.references :transport_line
      t.datetime :time

      t.timestamps
    end
  end
end
