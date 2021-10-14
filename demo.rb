w = 'romantizm'

def rev(word)
  (word.length / 2).times do |i|
    word[i], word[-i-1] = word[-i-1], word[i]
  end
  word
end

p rev(w)
