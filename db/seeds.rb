require 'csv'

def csv_rows_for(csv_file_name)
  data_folder = Rails.root.join('db/data')
  csv_text = File.read(data_folder.join(csv_file_name))

  CSV.parse(csv_text, headers: true)
end

ActiveRecord::Base.transaction do
  # Import lines.csv
  TransportLine.destroy_all

  csv_rows_for('lines.csv').each do |row|
    TransportLine.create!(
      id: (row['line_id'].to_i + 1),
      name: row['line_name'],
    )
  end

  # Import delays.csv
  TransportDelay.destroy_all

  csv_rows_for('delays.csv').each do |row|
    TransportDelay.create!(
      transport_line: ::TransportLine.find_by(name: row['line_name']),
      delay: row['delay']
    )
  end

  # Handling transport stop
  TransportStop.destroy_all

  csv_rows_for('stops.csv').each do |row|
    TransportStop.create!(
      id: (row['stop_id'].to_i + 1),
      x: row['x'],
      y: row['y'],
    )
  end

  # Handling transport stop
  TransportTime.destroy_all

  csv_rows_for('times.csv').each do |row|
    TransportTime.create!(
      transport_line: TransportLine.find((row['line_id'].to_i + 1)),
      transport_stop: TransportStop.find((row['stop_id'].to_i + 1)),
      time: row['time'].to_datetime,
    )
  end

  # Create schedule for next 30 days
  # Every scheduled trip needs to be tracked. This is just my
  # OCD in play. Not required for the task.
  30.times do |day_index|
    csv_rows_for('times.csv').each do |row|
      TransportTime.create!(
        transport_line: TransportLine.find((row['line_id'].to_i + 1)),
        transport_stop: TransportStop.find((row['stop_id'].to_i + 1)),
        time: (row['time'].to_datetime + (day_index + 1)),
      )
    end
  end
end

