class Hangman 
  attr_reader :secret_word

  def initialize(dictionary_file = "google-10000-english-no-swears.txt")
    puts "Hangman game initialize"

    words = File.readlines(dictionary_file, chomp: true)
    filtered_words = words.select { |w| w.length.between?(5, 12)}

    @secret_word = filtered_words.sample

    @correct_guesses = []
    @wrong_guesses = []
  end

  def display_word
    @secret_word.chars.map { |l| @correct_guesses.include?(l) ? l: "_" }.join(" ")
  end

  def play
    puts "🎮 Game starting..."
    puts "Secret word has #{@secret_word.length} letters!"
  end
end
