# frozen_string_literal: true

require 'yaml'

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

    @lives ||= 12

    until (@secret_word.chars - @correct_guesses).empty? || @lives <= 0
      puts "\nWord: #{display_word}"
      puts "Wrong guesses: #{@wrong_guesses.join(', ')}"
      puts "Lives remaining: #{@lives}"
      print 'Enter a letter: '
      guess = gets.chomp.downcase

      if guess == 'save'
        save_game
        puts '👋 Game saved. Exiting...'
        return
      end

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

  private

  def save_dir
    File.join(__dir__, '..', 'save')
  end

  def save_game(filename = nil)
    Dir.mkdir(save_dir) unless Dir.exist?(save_dir)
    print 'enter a name for your save file or press enter: '
    input = gets.chomp
    filename = input unless input.strip.empty?

    filename ||= "hangman_#{Time.now.strftime('%Y%m%d%H%M%S')}.yml"
    filename += '.yml' unless filename.end_with?('.yml')
    path = File.join(save_dir, filename)

    state = {
      'secret_word' => @secret_word,
      'lives' => @lives,
      'correct_guesses' => @correct_guesses,
      'wrong_guesses' => @wrong_guesses
    }

    File.write(path, YAML.dump(state))
    puts "💾 Game saved to #{path}"
  end

  def self.load_game(filename)
    state = YAML.load_file(filename)
    game = new
    game.instance_variable_set(:@secret_word, state['secret_word'])
    game.instance_variable_set(:@lives, state['lives'])
    game.instance_variable_set(:@correct_guesses, state['correct_guesses'])
    game.instance_variable_set(:@wrong_guesses, state['wrong_guesses'])
    game
  end
end
