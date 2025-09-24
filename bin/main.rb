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
    hangman = Hangman.load_game(files.first)
  else
    puts 'No saved games found. Starting a new game...'
    hangman = Hangman.new
  end
else
  hangman = Hangman.new
end

hangman.play
