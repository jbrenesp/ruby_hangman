#!/usr/bin/env ruby
# frozen_string_literal: true

# bin/main.rb

require_relative '../lib/hangman'

puts 'Would you like to (1) start a new game or (2) load a saved game?'
choice = gets.chomp

if choice == '2'
  save_dir = File.join(__dir__, '..', 'save')
  files = Dir[File.join(save_dir, '*.yml')]

  if files.any?
    puts "Select a save file to load:"
    files.each_with_index { |f, i| puts "#{i + 1}: #{File.basename(f)}" }
    file_choice = gets.chomp.to_i
    filename = files[file_choice - 1] || files.first
    hangman = Hangman.load_game(filename)
  else
    puts "No saved games found. Starting a new game..."
    hangman = Hangman.new
  end
else
  hangman = Hangman.new
end

hangman.play
   
