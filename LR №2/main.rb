require 'terminal-table'
require_relative './table_print'
require_relative './calculation_methods'

class Menu
  def self.main
    file_name = enter_file_name
    byte_mode = enter_byte_mode

    open_file(file_name, byte_mode: byte_mode)
  end

  def self.open_file(file_path, byte_mode: false)
    if File.exist?(file_path)
      encoding = byte_mode ? 'UNICODE' : 'UTF-8'
      file = File.new(file_path, "r:#{encoding}")
      text = byte_mode ? file.read : file.read.downcase
      text = text.encode!(encoding)

      # data = freq_for(text, byte_mode)
      # data = relative_freq_for(text, byte_mode)
      # data = amount_info_for(text, byte_mode: byte_mode)
      # data = average_amount_info_for(text, byte_mode)
      data = ascii_symbol_info_for(text, byte_mode)
      total_amount_info = total_amount_info_for(text, byte_mode)
      print_table(data, total_amount_info, byte_mode)
    else
      Menu.file_not_found
    end
  end

  def self.enter_byte_mode
    print 'Byte mode (по умолчанию выкл.): '
    byte_mode = gets.chomp

    if byte_mode.downcase == 'y'
      byte_mode
    else
      false
    end
  end

  def self.enter_file_name
    loop do
      clear_screen
      print 'Введите название файла: '
      file_name = gets.chomp
      return file_name unless file_name.empty?
    end
  end

  def self.file_not_found
    puts "Файл не найден...\n\n"
  end

  def self.clear_screen
    system('clear')
  end
end

Menu.main