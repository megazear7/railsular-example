class Result < ActiveRecord::Base
  has_and_belongs_to_many :simulations

  def self.csv_file_path sim
    filename = App.find(1).iterative ? "iterative.csv" : "transient.csv"
    File.join(ENV['HOME'], "/crimson_files/", App.find(1).name.downcase.tr(' ', '_'), sim.job_directory_name, 'results', 'data', filename)
  end

  def self.csv_data simulations, y_var
    cols = []
    row_count = 0
    simulations.each do |sim|
      col_data = []
      row_count = 0
      CSV.foreach(csv_file_path(sim), {headers: true}) do |row|
        row_count += 1
        col_data << row[y_var]
      end
      cols << col_data
    end

    CSV.generate do |csv|
      header_row = ["x"]
      simulations.each do |sim|
        header_row << sim.name
      end
      csv << header_row
      (1..row_count).each do |row|
        row_data = [row]
        cols.each do |col|
          row_data << col[row]
        end
        csv << row_data
      end
    end
  end

  def csv_data
    Result.csv_data self.simulations, self.y_var
  end
end
