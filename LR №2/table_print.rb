def change_invisible!
  each do |row|
    (row[0] = :пробел) if row[0] == ' '
    (row[0] = :перенос) if row[0] == "\n"
  end
  self
end

def sort_table!
  sort! { |a, b| b[1] <=> a[1] }
end

def print_table(data, total_amount_info, byte_mode)
  table = Terminal::Table.new
  table.title = 'Отчет по лабораторной работе 2'
  header = (byte_mode ? %w[Октет] : %w[Символ])

  header +=
    case data.first.size
    when 2
      %w[Частота]
    when 3
      %w[Частота Отн.частота]
    when 4
      %w[Частота Отн.частота Кол.информации]
    when 5
      %w[Частота Отн.частота Кол.информации Сред.кол.информации]
    when 6
      %w[Частота Отн.частота Кол.информации Сред.кол.информации ASCII]
    else
      %w[]
    end

  table.headings = header
  table.rows = data
  table.style = { border: :unicode, all_separators: true }
  puts "\n#{table}"
  puts "Общее кол.информации: #{total_amount_info}"
end