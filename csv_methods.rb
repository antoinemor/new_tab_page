require 'csv'

def read_csv(csv_file)
  ouput = CSV.read(csv_file)[0]
end

def write_csv(csv_file, content)
  CSV.open(csv_file, 'wb') { |csv| csv << [content[0], content[1], content[2]] }
end
