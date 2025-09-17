# frozen_string_literal: true

# Class representing a command-line Hangman game
class Hangman
  attr_reader :secret_word

  def initialize(dictionary_file = 'google-10000-english-no-swears.txt')
    puts 'Hangman game initialize'

    words = File.readlines(dictionary_file, chomp: true)
    filtered_words = words.select { |w| w.length.between?(5, 12) }

    @secret_word = filtered_words.sample

    @correct_guesses = []
    @wrong_guesses = []
  end

  def display_word
    @secret_word.chars.map { |l| @correct_guesses.include?(l) ? l : '_' }.join(' ')
  end

  def play
    puts '🎮 Game starting...'
    puts "Secret word has #{@secret_word.length} letters!"

    @lives = 6

    until (@secret_word.chars - @correct_guesses).empty? || @lives <= 0
      puts "\nWord: #{display_word}"
      puts "Wrong guesses: #{@wrong_guesses.join(', ')}"
      puts "Lives remaining: #{@lives}"
      print 'Enter a letter: '
      guess = gets.chomp.downcase

      if (@correct_guesses + @wrong_guesses).include?(guess)
        puts "⚠️ You already guessed '#{guess}'. Try a different letter."
        next
      end

      if @secret_word.include?(guess)
        @correct_guesses << guess
        puts '✅ Correct!'
      else
        @wrong_guesses << guess
        @lives -= 1
        puts '❌ Incorrect!'
      end
    end

    if (@secret_word.chars - @correct_guesses).empty?
      puts "🎉 You guessed the word: #{@secret_word}!"
    else
      puts "💀 You ran out of lives! The word was: #{@secret_word}."
    end
  end
end
