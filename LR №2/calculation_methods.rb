require_relative './table_print'

def freq_for(text, byte_mode)
  table = []

  if byte_mode
    text.each_byte do |byte| # перебор по боайтам
      hex = byte.to_s(16)
      (row = table.assoc(hex)) ? row[1] += 1 : table << [hex, 1]
    end
  else
    text.each_char do |char|  # перебор по буквам 
      (row = table.assoc(char)) ? row[1] += 1 : table << [char, 1]
    end

    table.send(:change_invisible!)
  end

  table.send(:sort_table!)
end

def relative_freq_for(text, byte_mode)
  table = freq_for(text, byte_mode)

  table.each do |row|
    row << format('%.16f', row[1].to_f / text.size)
  end

  table
end

def amount_info_for(text, byte_mode)
  table = relative_freq_for(text, byte_mode)

  table.each do |row|
    row << format('%.16f', -Math.log2(row[2].to_f))
  end

  table
end

def average_amount_info_for(text, byte_mode)
  table = amount_info_for(text, byte_mode)

  table.each do |row|
    row << format('%.16f', row[2].to_f * row[3].to_f)
  end

  table
end

def ascii_symbol_info_for(text, byte_mode)
  table = average_amount_info_for(text, byte_mode)

  table.each do |row|
    row <<
      if (row[0] == :пробел) || (row[0] == :перенос)
        "\e[32mtrue\e[0m"
      else
        from_ascii =
          if byte_mode
            CGI.unescape_html("&##{row[0].hex};").ascii_only?
          else
            row[0].ascii_only?
          end
        from_ascii ? "\e[32mtrue\e[0m" : "\e[31mfalse\e[0m"
      end
  end

  table
end

def total_amount_info_for(text, byte_mode)
  table = amount_info_for(text, byte_mode)
  total = 0

  table.each { |row| total += row[3].to_f }

  total
end